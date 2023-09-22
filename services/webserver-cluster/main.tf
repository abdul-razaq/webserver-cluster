locals {
  http_port = 80
  any_port = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips = ["0.0.0.0/0"]
}

resource "aws_security_group" "security_group" {
  name = "${var.cluster_name}-security-group"
}

resource "aws_security_group_rule" "instance_security_group" {
  type = "ingress"
  security_group_id = aws_security_group.security_group.id

  from_port = var.server_port
  to_port = var.server_port
  protocol = local.tcp_protocol
  cidr_blocks = local.all_ips
}

resource "aws_launch_configuration" "launch_config" {
  image_id = var.ami
  instance_type = var.instance_type
  security_groups = [aws_security_group.security_group.id]

  user_data = templatefile("${path.module}/user-data.sh", {
    server_port = var.server_port
    db_address = data.terraform_remote_state.db.outputs.db_address
    db_port = data.terraform_remote_state.db.outputs.db_port
    server_data = var.server_data
  })

  # This is Required when using a launch configuration with an auto scaling group.
  lifecycle {
    create_before_destroy = true
  }

  # user_data_replace_on_change = true

  # tags = {
  #   Name = "terraform_instance"
  # }
}

resource "aws_autoscaling_group" "autoscaling_group" {
  name = "${var.cluster_name}-${aws_launch_configuration.launch_config.name}"
  launch_configuration = aws_launch_configuration.launch_config.name
  vpc_zone_identifier = data.aws_subnets.default_vpc_subnets.ids
  target_group_arns = [aws_lb_target_group.load_balancer_target_group.arn]
  health_check_type = "ELB"

  min_size = var.min_size
  max_size = var.max_size
  min_elb_capacity = var.min_size

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key = "Name"
    value = var.cluster_name
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.custom_tags

    content {
      key = tag.key
      value = tag.value
      propagate_at_launch = true
    }
  }
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  autoscaling_group_name = aws_autoscaling_group.autoscaling_group.name

  count = var.enable_autoscaling ? 1 : 0
  
  scheduled_action_name = "${var.cluster_name}-scale-out-during-business-hours"
  min_size = 2
  max_size = 10
  desired_capacity = 10
  recurrence = "0 9 * * *"
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  autoscaling_group_name = aws_autoscaling_group.autoscaling_group.name

  count = var.enable_autoscaling ? 1 : 0

  scheduled_action_name = "${var.cluster_name}-scale-in-at-night"
  min_size = 2
  max_size = 10
  desired_capacity = 2
  recurrence = "0 17 * * *"
}

resource "aws_lb" "load_balancer" {
  name = "${var.cluster_name}-load-balancer"
  load_balancer_type = "application"
  subnets = data.aws_subnets.default_vpc_subnets.ids
  security_groups = [aws_security_group.alb_security_group.id]
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port = local.http_port
  protocol = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code = 404
    }
  }
}

resource "aws_lb_listener_rule" "alb_listener_rule" {
  listener_arn = aws_lb_listener.alb_listener.arn
  priority = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.load_balancer_target_group.arn
  }
}

resource "aws_security_group" "alb_security_group" {
  name = "${var.cluster_name}-alb-security-group"
}

resource "aws_security_group_rule" "allow_inbound_http" {
  security_group_id = aws_security_group.alb_security_group.id
  type = "ingress"

  from_port = local.http_port
  to_port = local.http_port
  protocol = local.tcp_protocol
  cidr_blocks = local.all_ips
}

resource "aws_security_group_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.alb_security_group.id
  type = "egress"

  from_port = local.any_port
  to_port = local.any_port
  protocol = local.any_protocol
  cidr_blocks = local.all_ips
}

resource "aws_lb_target_group" "load_balancer_target_group" {
  name = "${var.cluster_name}-lb-target-group"
  port = var.server_port
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default_vpc.id

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

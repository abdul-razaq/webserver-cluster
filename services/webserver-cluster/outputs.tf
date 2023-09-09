
# output "public_ip" {
#   description = "The public ip address of the created web server instance"
#   value = aws_instance.my_instance[0].public_ip
# }

output "alb_dns_name" {
  value = aws_lb.load_balancer.dns_name
  description = "The domain name of the load balancer"
}

output "asg_name" {
  value = aws_autoscaling_group.autoscaling_group.name
  description = "The name of the Auto Scaling Group"
}

output "alb_security_group_id" {
  description = "The ID of the Security Group attached to the load balancer"
  value = aws_security_group.alb_security_group.id
}

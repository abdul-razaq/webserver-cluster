data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnets" "default_vpc_subnets" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}

data "terraform_remote_state" "db" {
  backend = "s3"

  config = {
    bucket = var.db_remote_state_bucket
    key = var.db_remote_state_key
    region = "us-east-2"
  }
}

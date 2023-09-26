terraform {
  required_version = "~> 1.5.7"
  required_providers {
    aws = {
      version = "~> 5.17.0"
      source = "hashicorp/aws"
    }
  }
}

resource "aws_db_instance" "database" {
  identifier_prefix = "${var.db_resource_name}-instance"
  allocated_storage = 10
  instance_class = "db.t2.micro"
  skip_final_snapshot = true

  backup_retention_period = var.backup_retention_period

  replicate_source_db = var.replicate_source_db

  engine = var.replicate_source_db == null ? "mysql" : null
  db_name = var.replicate_source_db == null ? var.db_name : null
  username = var.replicate_source_db == null ? var.db_username : null
  password = var.replicate_source_db == null ? var.db_password : null
}

output "db_address" {
  description = "This is the endpoint for the database"
  value = aws_db_instance.database.address
}

output "db_port" {
  description = "This is the port for the database"
  value = aws_db_instance.database.port
}

output "database_arn" {
  description = "The ARN of the database"
  value = aws_db_instance.database.arn
}

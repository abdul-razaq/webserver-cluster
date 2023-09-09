output "db_address" {
  description = "This is the endpoint for the database"
  value = aws_db_instance.database.address
}

output "db_port" {
  description = "This is the port for the database"
  value = aws_db_instance.database.port
}

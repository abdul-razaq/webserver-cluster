variable "db_username" {
  description = "The database master username"
  type = string
  sensitive = true
}

variable "db_password" {
  description = "The database master password"
  type = string
  sensitive = true
}

variable "db_resource_name" {
  description = "The database identifier prefix"
  type = string
}

variable "db_name" {
  description = "The database name"
  type = string
}
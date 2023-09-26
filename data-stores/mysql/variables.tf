variable "db_username" {
  description = "The database master username"
  type = string
  sensitive = true
  default = null
}

variable "db_password" {
  description = "The database master password"
  type = string
  sensitive = true
  default = null
}

variable "db_resource_name" {
  description = "The database identifier prefix"
  type = string
}

variable "db_name" {
  description = "The database name"
  type = string
  default = null
}

variable "backup_retention_period" {
  description = "Days to retain backups. Must be > 0 to enable replication"
  type = number
  default = null
}

variable "replicate_source_db" {
  description = "If specified, replicate the RDS database at the given ARN"
  type = string
  default = null
}

variable "server_port" {
  description = "This is the port the web server will listen on for incoming request"
  type = number
  default = 8080
}

variable "cluster_name" {
  description = "The name to use for all the cluster resources in each envirnoment"
  type = string
}

variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket for storing the remote state file for the database resource"
  type = string
}

variable "db_remote_state_key" {
  description = "The path where the database's remote state file is stored in the S3 bucket"
  type = string
}

variable "ami" {
  description = "The Amazon Machine Image to use in the launch configuration"
  type = string
  default = "ami-0fb653ca2d3203ac1"
}

variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g t2.micro)"
  type = string
}

variable "min_size" {
  description = "The minimum number of EC2 Instances to run in the ASG"
  type = number
}

variable "max_size" {
  description = "The maximum number of EC2 Instances to run in the ASG"
}

variable "custom_tags" {
  description = "Custom tags to add to specific resources, e.g The ASG resource."
  type = map(string)
  default = {}
}

variable "enable_autoscaling" {
  description = "Whether to enable autoscaling in the module"
  type = bool
  default = false
}

variable "server_data" {
  description = "The data to serve in the server"
  type = string
  default = "Hello World"
}


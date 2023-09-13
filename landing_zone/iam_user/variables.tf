variable "iam_user" {
  description = "The IAM user to create"
  type = string
}

variable "give_user_cloudwatch_full_access" {
  description = "whether to give the user full cloudwatch access or just read-only cloudwatch access"
  type = bool
  default = false  
}

output "iam_users_arns" {
  description = "The ARN of the created IAM users"
  value = aws_iam_user.iam_user.arn
}

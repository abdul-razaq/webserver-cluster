output "iam_users_arns" {
  description = "The ARN of the created IAM users"
  value = aws_iam_user.iam_user.arn
}

output "iam_user_cloudwatch_policy_arn" {
  description = "Prints the ARN of the cloudwatch IAM policy that got applied to the IAM user. i.e which of the policies got applied to the IAM user, either the read-only version of the policy or the full-access version of the policy"
  value = one(concat(aws_iam_user_policy_attachment.iam_user_cloudwatch_read-only_access[*].policy_arn, aws_iam_user_policy_attachment.iam_user_cloudwatch_full_access[*].policy_arn))
}

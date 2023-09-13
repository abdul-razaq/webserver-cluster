resource "aws_iam_user" "iam_user" {
  name = var.iam_user
}

resource "aws_iam_policy" "cloudwatch_read_only" {
  name = "cloudwatch-read-only"
  policy = data.aws_iam_policy_document.cloudwatch_read_only.json
}

resource "aws_iam_policy" "cloudwatch_full_access" {
  name = "cloudwatch-full-access"
  policy = data.aws_iam_policy_document.cloudwatch_full_access.json
}

resource "aws_iam_user_policy_attachment" "iam_user_cloudwatch_read-only_access" {
  count = var.give_user_cloudwatch_full_access ? 0 : 1
  policy_arn = aws_iam_policy.cloudwatch_read_only.arn
  user = aws_iam_user.iam_user.name
}

resource "aws_iam_user_policy_attachment" "iam_user_cloudwatch_full_access" {
  count = var.give_user_cloudwatch_full_access ? 1 : 0
  policy_arn = aws_iam_policy.cloudwatch_full_access.arn
  user = aws_iam_user.iam_user.name
}

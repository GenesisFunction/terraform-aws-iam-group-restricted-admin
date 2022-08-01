resource "aws_iam_role" "this" {
  name               = "${var.group_name}-role"
  tags               = var.input_tags
  assume_role_policy = data.aws_iam_policy_document.cross_account_assume_role_policy_mfa.json
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

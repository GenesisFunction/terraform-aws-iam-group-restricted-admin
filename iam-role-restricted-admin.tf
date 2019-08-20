resource "aws_iam_role" "this" {
  name               = "${var.group_name}-role"
  tags               = var.input_tags
}

resource "aws_iam_role_policy_attachment" "cross_account_assume_role" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}


resource "aws_iam_policy" "this" {
  name        = "${var.group_name}-policy"
  description = "Policy to grant restricted admin. This admin can't do some functions such as delete the CloudTrail audit trail."
  policy      = data.aws_iam_policy_document.iam_restricted_admin.json
}


data "aws_iam_policy_document" "this" {
  statement {
    sid = "AllowFullAdminExceptSomeWithMFA"
    not_actions = [
      "logs:Delete*",
      "cloudtrail:Delete*",
      "cloudtrail:Stop*",
      "cloudtrail:Update*",
      "sts:AssumeRole",
      "sts:AssumeRoleWithSAML",
      "sts:AssumeRoleWithWebIdentity",
      "sts:GetFederationToken",
    ]
    resources = [
      "*",
    ]
  }
  statement {
    sid = "AllowFullAdminExceptSomeS3WithMFA"
    not_actions = [
      "s3:Delete*",
      "s3:Put*",
    ]
    resources = var.s3_bucket_paths_to_protect
  }
}

resource "aws_iam_policy" "this" {
  name        = "${var.group_name}-policy"
  description = "Policy to grant restricted admin. This admin can't do some functions such as delete the CloudTrail audit trail."
  policy      = data.aws_iam_policy_document.this.json
}


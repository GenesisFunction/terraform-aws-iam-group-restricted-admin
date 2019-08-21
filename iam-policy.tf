data "aws_iam_policy_document" "restricted_admin" {
  statement {
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
    
    sid = "AllowFullAdminExceptSome"
  }
  statement {
    not_actions = [
      "s3:Delete*",
      "s3:Put*",
    ]
    resources = var.s3_bucket_paths_to_protect
    sid = "AllowFullAdminExceptSomeS3"
  }
  statement {
    effect = "Deny"
    not_actions = [
      "iam:CreateVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:GetUser",
      "iam:ListMFADevices",
      "iam:ListVirtualMFADevices",
      "iam:ResyncMFADevice",
      "sts:GetSessionToken"
    ]
    resources = [
      "*"
    ]
    condition {
      test     = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"

      values = [
        "false"
      ]
    }
    sid = "DenyAllExceptListedIfNoMFA"
  }
}

resource "aws_iam_policy" "this" {
  name        = "${var.group_name}-policy"
  description = "Policy to grant restricted admin. This admin can't do some functions such as delete the CloudTrail audit trail."
  policy      = data.aws_iam_policy_document.restricted_admin.json
}


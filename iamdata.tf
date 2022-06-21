data "aws_iam_policy_document" "cross_account_assume_role_policy_mfa" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }

    actions = ["sts:AssumeRole"]

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values = [
        "true",
      ]
    }
  }
}

data "aws_iam_policy_document" "iam_restricted_admin" {
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
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

data "aws_iam_policy_document" "role_assumption" {
  statement {
    sid = "AssumeRole"

    actions = [
        "sts:AssumeRole"
    ]

    effect = "Allow"

    resources = [
      aws_iam_role.this.arn
    ]

    condition {
      test     = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"

      values = [
        "true"
      ]
    }
  }
}

data "aws_iam_policy_document" "user_self_service_policy" {
  statement {
    sid = "ListUsersAccessWithoutMFA"

    actions = [
      "iam:ListVirtualMFADevices"
    ]

    effect = "Allow"

    resources = [
      "*",
    ]
  }

  statement {
    sid = "SelfServiceAccessWithoutMFA"

    actions = [
        "iam:List*",
        "iam:GetUser",
        "iam:GetAccountPasswordPolicy",
        "iam:ChangePassword",
        "iam:CreateVirtualMFADevice",
        "iam:EnableMFADevice"
    ]

    effect = "Allow"

    resources = [
      "arn:aws:iam::*:user/$${aws:username}",
      "arn:aws:iam::*:mfa/$${aws:username}"
    ]
  }

  statement {
    sid = "SelfServiceAccessWithMFA"

    actions = [
        "iam:Get*",
        "iam:DeleteSSHPublicKey",
        "iam:GetSSHPublicKey",
        "iam:ListSSHPublicKeys",
        "iam:UpdateSSHPublicKey",
        "iam:UploadSSHPublicKey",
        "iam:CreateAccessKey",
        "iam:DeleteAccessKey",
        "iam:UpdateAccessKey",
        "iam:DeleteVirtualMFADevice",
        "iam:DeactivateMFADevice",
        "iam:ResyncMFADevice",
        "iam:UploadSigningCertificate",
        "iam:UpdateSigningCertificate",
        "iam:DeleteSigningCertificate",
        "iam:GenerateServiceLastAccessedDetails"
    ]

    effect = "Allow"

    resources = [
      "arn:aws:iam::*:user/$${aws:username}",
      "arn:aws:iam::*:mfa/$${aws:username}"
    ]

    condition {
      test     = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"

      values = [
        "true"
      ]
    }
  }

  statement {
    sid = "DenyAllExceptListedIfNoMFA"

    not_actions = [
        "iam:ListVirtualMFADevices",
        "iam:List*",
        "iam:GetUser",
        "iam:GetAccountPasswordPolicy",
        "iam:EnableMFADevice",
        "iam:CreateVirtualMFADevice",
        "iam:ChangePassword"
    ]

    effect = "Deny"

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
  }
}

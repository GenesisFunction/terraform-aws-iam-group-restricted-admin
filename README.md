# iam-group-restricted-admin
iam-group-restricted-admin creates a group and associated policies/roles to be able to grant users a restricted admin policy (full admin minus deletion of logs, cloudtrail, etc.) in addition to user self service rights. The default policy requires MFA access for console, but not role assumption(though the role can be switched into), and requires role assumption for cli (only way to do MFA in cli).

This is meant to be used as a one and done solution for people with a single AWS account who want to have/enforce MFA access on their admins.

### Example Usage:
```
module "iam_group_restricted_admin" {
  source  = "GenesisFunction/iam-group-restricted-admin/aws"
  version = "1.0.0"
  # source  = "github.com/GenesisFunction/terraform-aws-iam-group-restricted-admin"

  group_name = "${name_prefix}-restricted-admin"

  s3_bucket_paths_to_protect = [
    module.cloudtrail.s3_bucket_arn,
    "${module.cloudtrail.s3_bucket_arn}/*"
  ]

  input_tags = merge(local.common_tags, {})
}
```

### Using different policies
To use this as a template for a different set of permissions, change the policy document and description in iam-policy.tf


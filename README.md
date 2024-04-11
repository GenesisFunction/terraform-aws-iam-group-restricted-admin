<!-- BEGIN_TF_DOCS -->
<p align="center">
  <img src="https://github.com/StratusGrid/terraform-readme-template/blob/main/header/stratusgrid-logo-smaller.jpg?raw=true" />
  <p align="center">
    <a href="https://stratusgrid.com/book-a-consultation">Contact Us</a> |
    <a href="https://stratusgrid.com/cloud-cost-optimization-dashboard">Stratusphere FinOps</a> |
    <a href="https://stratusgrid.com">StratusGrid Home</a> |
    <a href="https://stratusgrid.com/blog">Blog</a>
  </p>
</p>

# terraform-aws-iam-group-restricted-admin

GitHub: [StratusGrid/terraform-aws-iam-group-restricted-admin](https://github.com/StratusGrid/terraform-aws-iam-group-restricted-admin)

This module creates a group and associated policies/roles to be able to grant users a restricted admin policy (full admin minus deletion of logs, cloudtrail, etc.) in addition to user self service rights. 
The default policy requires MFA access for console, but not role assumption (though the role can be switched into), and requires role assumption for cli (best way to do MFA in cli).

This is meant to be used as a one and done solution for people with a single AWS account who want to have/enforce MFA access on their admins.

## Example usage of the module:
```hcl
module "iam_group_restricted_admin" {
  source  = "GenesisFunction/iam-group-restricted-admin/aws"
  version = "1.0.2"
  # source  = "github.com/GenesisFunction/terraform-aws-iam-group-restricted-admin"

  group_name = "${name_prefix}-restricted-admin"

  s3_bucket_paths_to_protect = [
    module.cloudtrail.s3_bucket_arn,
    "${module.cloudtrail.s3_bucket_arn}/*"
  ]

  input_tags = merge(local.common_tags, {})
}
```
---

## Using different policies
To use this as a template for a different set of permissions, change the inputs, readme, and policy document/description in iam-policy.tf

<span style="color:red">NOTE:</span> The MFA restrictions come from the DENY on the user self service policy. If that is removed, you should make two of the restricted-admin (or your replacement) policies. Make one to be used in the role and not have the BOOL MFA conditions, and have another one for the direct group attachment and have the conditions.

---

## Resources

| Name | Type |
|------|------|
| [aws_iam_group.group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group) | resource |
| [aws_iam_group_policy.role_assumption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy) | resource |
| [aws_iam_group_policy.user_self_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy) | resource |
| [aws_iam_group_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy_attachment) | resource |
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_group_name"></a> [group\_name](#input\_group\_name) | Unique string name of iam group to be created. Also prepends supporting resource names | `string` | n/a | yes |
| <a name="input_group_path"></a> [group\_path](#input\_group\_path) | The path (prefix) for the group in IAM | `string` | `"/"` | no |
| <a name="input_input_tags"></a> [input\_tags](#input\_input\_tags) | Map of tags to apply to resources | `map(string)` | <pre>{<br>  "Developer": "GenesisFunction",<br>  "Provisioner": "Terraform"<br>}</pre> | no |
| <a name="input_s3_bucket_paths_to_protect"></a> [s3\_bucket\_paths\_to\_protect](#input\_s3\_bucket\_paths\_to\_protect) | List of bucket matching ARNs which the restricted admin should not be able to delete or put in. Commonly used for cloudtrail and logging buckets... | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_group_id"></a> [iam\_group\_id](#output\_iam\_group\_id) | ID of IAM Group created |
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | ARN of IAM role created |
| <a name="output_iam_role_assumption_url"></a> [iam\_role\_assumption\_url](#output\_iam\_role\_assumption\_url) | URL to assume role in Console |

---

<span style="color:red">Note:</span> Manual changes to the README will be overwritten when the documentation is updated. To update the documentation, run `terraform-docs -c .config/.terraform-docs.yml .`
<!-- END_TF_DOCS -->
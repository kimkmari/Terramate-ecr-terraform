resource "aws_iam_openid_connect_provider" "github_oidc_provider" {
  count = local.github_oidc_enabled ? 1 : 0

  url = "https://${local.github_oidc_provider_url}"
  client_id_list = local.github_oidc_audiences
  thumbprint_list = local.github_oidc_thumbprints

  tags = var.tags
}

resource "aws_iam_role" "github_action_repo_role" {
  count = local.github_oidc_enabled && local.ecr_repo_iam_policies_json != null ? 1 : 0

  name = var.github_actions_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "${aws_iam_openid_connect_provider.github_oidc_provider[count.index].arn}"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringLike": {
            "${local.github_oidc_provider_url}:sub": "repo:${local.github_oidc_org_name}/${local.github_oidc_repo_name}:ref:refs/heads/${local.github_oidc_branch}"
          },
          "StringEquals": {
            "${local.github_oidc_provider_url}:aud": "${local.github_oidc_audiences}"
          }
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ecr_repo_policy" {
  count = local.github_oidc_enabled && local.ecr_repo_iam_policies != null ? length(local.ecr_repo_iam_policies) : 0

  policy_arn = local.ecr_repo_iam_policies[count.index]
  role       = aws_iam_role.github_action_repo_role[count.index].name
}


# ---------------------------------------------------------------------------------------------------------------------
# Iam policies attach by json 
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_iam_policy" "ecr_repo_policy_json" {
  count       = local.ecr_repo_iam_policies_json != null ? length(local.ecr_repo_iam_policies_json) : 0

  description = "IAM Policy for the Service ECR"
  policy      = local.ecr_repo_iam_policies_json[count.index]

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "service_ecr_policy" {
  count      = local.ecr_repo_iam_policies_json != null ? length(local.ecr_repo_iam_policies_json) : 0

  policy_arn = aws_iam_policy.ecr_repo_policy_json[count.index].arn
  role       = aws_iam_role.github_action_repo_role[count.index].name
}


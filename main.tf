data "aws_organizations_organization" "current" {}

resource "aws_ecr_repository" "ecr_repository" {
  for_each = setunion(
    toset([for k,v in local.ecr_repo_config.base-images : join("/",[v.registry,v.image])]),
    toset([for k,v in local.ecr_repo_config.add-on-images : join("/",[v.registry,v.image])])
  )

  name                 = each.value
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository_policy" "ecr_repository_permission" {
  for_each = setunion(
    toset([for k,v in local.ecr_repo_config.base-images : join("/",[v.registry,v.image])]),
    toset([for k,v in local.ecr_repo_config.add-on-images : join("/",[v.registry,v.image])])
  )
  repository = each.value
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowPullForOrganization",
        Effect = "Allow",
        Principal = "*",
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:DescribeImages",
          "ecr:DescribeRepositories",
          "ecr:GetDownloadUrlForLayer"
        ],
        Condition = {
          "ForAnyValue:StringLike": {
            "aws:PrincipalOrgPaths": [
              "${data.aws_organizations_organization.current.id}/*/*/*"
            ]
          }
        }
      }
    ]
  })
  # 최초 배포 시 repository policy를 생성하려면 repository가 미리 생성되어 있어야 함.
  depends_on = [
    aws_ecr_repository.ecr_repository
  ]
}
##### 테라폼으로 관리되는 공통 태그를 지정합니다.
provider "aws" {
  region = local.region
  # assume_role {
  #   role_arn = join("", ["arn:aws:iam::", var.account_id, ":role/", var.TF_ROLE_NAME])
  # }
  default_tags {
    tags = {
      Environment      = local.env
      Project          = local.pjt
      COST_CENTER      = local.pjt
      TerraformManaged = true
      CodeRepo         = var.tf_github_repo
      CodePath         = var.tf_github_path
      CodeRevision     = var.tf_github_revision
    }
  }
}

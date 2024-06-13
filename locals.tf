locals {
  region     = var.region
  env        = var.env
  pjt        = var.pjt

  # ------------------------------------------------------------
  # GitHub organization and repository to authorize through OIDC
  # ------------------------------------------------------------
  github_oidc_org_name = var.github_oidc_org_name
  github_oidc_repo_name = var.github_oidc_repo_name
  github_oidc_branch = var.github_oidc_branch

  # ------------------------------------------------------------
  # GitHub OIDC provider config
  # ------------------------------------------------------------
  github_oidc_enabled = var.github_oidc_enabled
  github_oidc_provider_url = var.github_oidc_provider_url
  github_oidc_audiences = var.github_oidc_audiences
  github_oidc_thumbprints = var.github_oidc_thumbprints

  # ------------------------------------------------------------
  # IAM Role for ECR
  # ------------------------------------------------------------
  ecr_repo_iam_policies = []
  ecr_repo_iam_policies_json = [ file("./iam_policies/github_actions_policy.json") ]

  #----------------------------------------------------------
  # ECR REPOSITORIES
  #----------------------------------------------------------
  
  # Moved to config/images.yaml
  # ============================
  # ecr_repo_names = [
  #   "dockerhub-amazoncorretto-17-alpine",
  #   "dockerhub-amazonlinux-2",
  #   "samplesvc-java",
  #   "samplesvc-nginx",
  # ]

  ecr_repo_config = yamldecode(file("${path.module}/config/images.yaml"))
}
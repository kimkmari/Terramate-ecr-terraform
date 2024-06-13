##########
# Terraform Orga name
########
# variable "tfe-organization" {
#   default = "coe-poc"
# }

variable "account_id" {
  type = string
}

variable "TF_ROLE_NAME" {
  type = string
}

variable "region" {
  type        = string
  description = "AWS Region code"
  default     = "ap-northeast-2"
}

#####################
# default tag
#####################

variable "env" {
  default = "poc"
}

variable "pjt" {
  description = "(필수)프로젝트명, 서비스명"
  default     = "ecsa-gitops"
}

variable "service_id" {
  default = "eks-sandbox"
}

variable "costc" {
  default = "prd_wer"
}

variable "tags" {
  type = map(any)
  default = {
    made_by = "DevSecOps_Team"
  }
}

variable "tf_github_repo" {
  type        = string
  description = "테라폼 코드 리포"
  default     = "https://github.com/cloud-devops-modules/aws-shdpltf-tf-mgmt.git"
}

variable "tf_github_path" {
  type        = string
  description = "테라폼 코드 경로"
  default     = "/AWS/ECR-COMMON-REPO"
}

variable "tf_github_revision" {
  type        = string
  description = "테라폼 코드 브랜치"
  default     = "dev"
}

#----------------------------------------------------------
// ECR REPOSITORIES
#----------------------------------------------------------
variable "ecr_repo_names" {
  type        = list(string)
  description = "ECR repository names"
  default = [
    # Base Images
    "uplus-base-spring-java-11",

    # Add-on Images
    # TODO
  ]
}

variable "iam_policies_for_ecr_repo_json" {
  type        = list(string)
  description = "IAM Policies JSON for ECR Repository"
  default     = []
}

#----------------------------------------------------------
// GITHUB ACTIONS
#----------------------------------------------------------
variable "github_oidc_org_name" {
  type        = string
  description = "GitHub organization that will assume an IAM Role through OIDC"
  default     = "cloud-devops-modules"
} 

variable "github_oidc_repo_name" {
  type        = string
  description = "GitHub repo that will assume an IAM Role through OIDC"
  default     = "*"
}

variable "github_oidc_branch" {
  type        = string
  description = "GitHub branch that will assume an IAM Role through OIDC"
  default     = "*"
}

#----------------------------------------------------------
// OIDC PROVIDER
#----------------------------------------------------------
variable "github_oidc_enabled" {
  type        = bool
  description = "Is GitHub OIDC enabled"
  default     = true
}

variable "github_oidc_provider_url" {
  type        = string
  description = "GitHub OIDC provider URL"
  default     = "token.actions.githubusercontent.com"
}

variable "github_oidc_audiences" {
  type        = list(string)
  description = "Audiences for the GitHub OIDC provider"
  default     = ["sts.amazonaws.com"]
}

variable "github_oidc_thumbprints" {
  type        = list(string)
  description = "Hashes of the certificate from the GitHub OIDC provider"
  default     = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  ]
}

variable "github_actions_role_name" {
  type        = string
  description = "GitHub Actions IAM Role Name"
  default     = "github-action-common-repo-role"
}
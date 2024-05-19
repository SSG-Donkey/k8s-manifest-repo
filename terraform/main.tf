terraform {
  required_version = "1.7.5"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.3"
    }
  }
}
provider "aws" {
  region = var.region
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "arn:aws:eks:ap-northeast-2:227250033304:cluster/terraform-eks-donkey"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

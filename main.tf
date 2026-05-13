terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  cloud {}
}

provider "aws" {
  region = var.aws_region
}

data "terraform_remote_state" "platform" {
  backend = "remote"

  config = {
    organization = var.tfc_organization
    workspaces = {
      name = var.platform_workspace_name
    }
  }
}

module "rds_postgres" {
  source = "./modules/rds-postgres"

  project_name       = var.project_name
  environment        = var.environment
  db_username        = var.db_username
  db_password        = var.db_password
  vpc_id             = data.terraform_remote_state.platform.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.platform.outputs.private_subnet_ids
  app_security_group = data.terraform_remote_state.platform.outputs.app_security_group
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "fiap-mecanica"
}

variable "environment" {
  description = "Deployment environment (production, staging)"
  type        = string
  default     = "production"
}

variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-1"
}

variable "tfc_organization" {
  description = "Terraform Cloud organization that hosts the shared infrastructure workspace"
  type        = string
}

variable "platform_workspace_name" {
  description = "Terraform Cloud workspace name for the shared platform or kubernetes infrastructure"
  type        = string
}

variable "db_username" {
  description = "PostgreSQL database username"
  type        = string
  default     = "fiapmecanica"
  sensitive   = true
}

variable "db_password" {
  description = "PostgreSQL database password"
  type        = string
  sensitive   = true
}

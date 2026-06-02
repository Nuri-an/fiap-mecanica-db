# fiap-mecanica-db

Terraform repository for provisioning the AWS RDS PostgreSQL database used by the application.

## What this repo provisions

- AWS RDS PostgreSQL instance (`postgres` engine, version 15)
- DB subnet group using private subnets from shared VPC state
- Security group allowing application access to port `5432`
- PostgreSQL parameter group
- Secrets Manager secret for database credentials
- IAM role and policy for an RDS Proxy to read the secret
- RDS Proxy and proxy target group attached to the instance
- Outputs for database endpoint, proxy endpoint, database URL, and secret ARNs

## Terraform state and shared infrastructure

This repo uses an S3 backend:

- bucket: `fiap-mecanica-terraform-state`
- key: `db/terraform.tfstate`
- region: `us-east-1`

It also reads shared platform state from the same bucket:

- key: `k8s/terraform.tfstate`

The shared state must expose these outputs:

- `vpc_id`
- `private_subnet_ids`
- `app_security_group`

## Main configuration

The root `main.tf` file:

- configures the AWS provider with `var.aws_region`
- loads remote state from the shared VPC workspace
- calls the `modules/rds-postgres` module

Module inputs:

- `project_name`
- `environment`
- `db_username`
- `db_password`
- `vpc_id`
- `private_subnet_ids`
- `app_security_group`

## Outputs

The root module exports:

- `rds_endpoint`
- `rds_proxy_endpoint`
- `database_url`
- `db_secret_arn`
- `db_credentials_secret_arn`

## GitHub Actions workflow

Workflow: `.github/workflows/terraform.yml`

- `pull_request` on `main` runs plan only
- `push` on `develop` and `main` runs both plan and apply

Jobs:

- `plan`
  - Checkout
  - Configure AWS credentials with `AWS_ROLE_ARN`
  - Setup Terraform
  - `terraform init`
  - `terraform fmt -check -recursive`
  - `terraform validate`
  - `terraform plan`

- `apply`
  - Runs only on push
  - Uses GitHub environment `staging` for `develop` and `production` for `main`
  - `terraform apply -auto-approve`
  - Exports `db_secret_arn`
  - If `API_REPOSITORY` is provided, syncs `DB_SECRET_ARN` to the API repository

## Required secrets

- `DB_USERNAME`
- `DB_PASSWORD`
- `AWS_ROLE_ARN`
- `GH_PAT`

## Optional repository variables

- `AWS_REGION` (default: `us-east-1`)
- `API_REPOSITORY` (optional repo path used for secret sync, e.g. `org/fiap-mecanica-api`)

## Branch mapping

- `develop` -> `TF_VAR_environment=hmg`, GitHub environment `staging`
- `main` -> `TF_VAR_environment=prod`, GitHub environment `production`

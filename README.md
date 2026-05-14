# fiap-mecanica-db

Terraform project for provisioning the managed database (AWS RDS PostgreSQL) used by the application.

## Pipeline

Workflow: `.github/workflows/terraform.yml`

- Pull Request: `fmt` + `init` + `validate` + `plan`
- Push to `develop`: `init` + `apply` in homolog
- Push to `main`: `init` + `apply` in production

## Secrets/Vars (GitHub)

Configure `secrets` and `vars` inside each GitHub environment (`Homolog` and `Production`).

Required secrets:

- `DB_USERNAME`
- `DB_PASSWORD`
- `GH_PAT`
- `TF_API_TOKEN`

Required vars:

- `TF_CLOUD_ORGANIZATION`
- `TF_WORKSPACE_HMG`
- `TF_WORKSPACE_PROD`
- `TF_PLATFORM_WORKSPACE_HMG`
- `TF_PLATFORM_WORKSPACE_PROD`

Optional vars:

- `AWS_REGION` (default: `us-east-1`)
- `PROJECT_NAME` (default: `fiap-mecanica-db`)

## Environments

Create the following GitHub environments:

- `Homolog`
- `Production`

Recommended source for secrets:

- `DB_USERNAME`: manually configured in GitHub, defined by you for each environment
- `DB_PASSWORD`: manually configured in GitHub, defined by you for each environment
- `GH_PAT`: manually configured in GitHub, token with permission to update secrets in another repository

Recommended source for vars:

- `TF_CLOUD_ORGANIZATION`: manually configured in GitHub, Terraform Cloud organization name
- `TF_WORKSPACE_HMG`: manually configured in GitHub, Terraform Cloud workspace name for this repository's homolog database workspace
- `TF_WORKSPACE_PROD`: manually configured in GitHub, Terraform Cloud workspace name for this repository's production database workspace
- `TF_PLATFORM_WORKSPACE_HMG`: manually configured in GitHub, Terraform Cloud workspace name for the shared homolog infrastructure/platform state
- `TF_PLATFORM_WORKSPACE_PROD`: manually configured in GitHub, Terraform Cloud workspace name for the shared production infrastructure/platform state
- `AWS_REGION`: manually configured in GitHub, or default `us-east-1`
- `PROJECT_NAME`: manually configured in GitHub, or default `fiap-mecanica-db`

## `environment` Variable

The Terraform `environment` variable and the GitHub Actions `environment` are different concepts, but they were aligned here:

- `develop` branch uses GitHub Environment `Homolog`
- `main` branch uses GitHub Environment `Production`
- each job defines `environment` with the Terraform environment value

In practice:

- `develop` sends `environment=hmg`
- `main` sends `environment=prod`

This variable reaches `main.tf` and is passed to the `rds_postgres` module as `var.environment`.

## Terraform Cloud

To use Terraform Cloud, the backend in `main.tf` is now `cloud`.
The real `organization` and `workspace` values are injected during `terraform init` by the example workflow `terraform.yml`.

Suggested workspaces:

- `fiap-mecanica-db-hmg`
- `fiap-mecanica-db-prod`

The database repository also uses `data "terraform_remote_state"` to read outputs from the shared infrastructure workspace:

- `vpc_id`
- `private_subnet_ids`
- `app_security_group`

These outputs must exist in the remote platform workspace or in `fiap-mecanica-api`.

## Inputs

Required variables to create the RDS inside the network/cluster:

- `tfc_organization`
- `platform_workspace_name`

## Cross-repository secret sync

After a successful apply, the workflow exports the Terraform output
`database_url` and updates the `DATABASE_URL` GitHub secret in the
`fiap-mecanica-api` repository.

This requires:

- `GH_PAT` with permission to manage repository secrets

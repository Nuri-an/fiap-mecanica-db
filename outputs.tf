output "rds_endpoint" {
  description = "RDS PostgreSQL endpoint"
  value       = module.rds_postgres.endpoint
  sensitive   = true
}

output "rds_proxy_endpoint" {
  description = "RDS proxy endpoint"
  value       = module.rds_postgres.proxy_endpoint
  sensitive   = true
}

output "database_url" {
  description = "PostgreSQL connection string for the application"
  value       = module.rds_postgres.database_url
  sensitive   = true
}

output "db_secret_arn" {
  description = "Secrets Manager ARN for DB credentials (RDS proxy)"
  value       = module.rds_postgres.db_credentials_secret_arn
  sensitive   = true
}

output "db_credentials_secret_arn" {
  description = "Secrets Manager ARN for DB credentials (RDS proxy)"
  value       = module.rds_postgres.db_credentials_secret_arn
  sensitive   = true
}

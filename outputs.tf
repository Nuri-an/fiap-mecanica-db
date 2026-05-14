output "rds_endpoint" {
  description = "RDS PostgreSQL endpoint"
  value       = module.rds_postgres.endpoint
  sensitive   = true
}

output "database_url" {
  description = "PostgreSQL connection string for the application"
  value       = module.rds_postgres.database_url
  sensitive   = true
}

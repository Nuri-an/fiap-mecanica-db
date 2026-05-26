output "endpoint" {
  value     = aws_db_instance.main.endpoint
  sensitive = true
}

output "proxy_endpoint" {
  value     = aws_db_proxy.main.endpoint
  sensitive = true
}

output "database_url" {
  value     = "postgresql://${var.db_username}:${var.db_password}@${aws_db_instance.main.endpoint}/fiapmecanica"
  sensitive = true
}

output "db_credentials_secret_arn" {
  value     = aws_secretsmanager_secret.db_credentials.arn
  sensitive = true
}

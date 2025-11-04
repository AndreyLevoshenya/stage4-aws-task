output "postgres_endpoint" {
  description = "The endpoint of the PostgreSQL RDS instance"
  value       = aws_db_instance.postgres.endpoint
}

output "postgres_port" {
  description = "The port on which PostgreSQL RDS is listening"
  value       = aws_db_instance.postgres.port
}

output "postgres_username" {
  description = "Username for PostgreSQL RDS"
  value       = aws_db_instance.postgres.username
}

output "postgres_password" {
  description = "Password for PostgreSQL RDS"
  sensitive   = true
  value       = aws_db_instance.postgres.password
}

output "postgres_sg_id" {
  description = "Security group ID for the PostgreSQL RDS"
  value       = aws_security_group.postgres_sg.id
}

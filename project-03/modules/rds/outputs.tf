output "db_endpoint" {
  description = "RDS database endpoint"
  value       = aws_db_instance.this.endpoint
}

output "db_identifier" {
  description = "RDS database identifier"
  value       = aws_db_instance.this.identifier
}

output "db_address" {
  description = "RDS database address"
  value       = aws_db_instance.this.address
}

output "db_port" {
  description = "RDS database port"
  value       = aws_db_instance.this.port
}
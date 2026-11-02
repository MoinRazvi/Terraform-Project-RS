# EC2 Outputs

output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = module.ec2.instance_id
}

output "ec2_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.ec2.public_ip
}

output "ec2_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = module.ec2.private_ip
}


# RDS Outputs

output "rds_endpoint" {
  description = "Endpoint of the RDS database"
  value       = module.rds.db_endpoint
}

output "rds_identifier" {
  description = "Identifier of the RDS database"
  value       = module.rds.db_identifier
}
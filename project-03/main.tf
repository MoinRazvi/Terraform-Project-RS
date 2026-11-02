
# Read networking resources from the foundation state
data "terraform_remote_state" "networking" {
  backend = "local"

  config = {
    path = "${path.module}/foundation/terraform.tfstate"
  }
}

# Workspace-specific configuration
locals {
  environment = terraform.workspace

  instance_types = {
    dev = "t3.micro"
    qa  = "t3.small"
  }

  db_instance_classes = {
    dev = "db.t3.micro"
    qa  = "db.t3.micro"
  }
}

# EC2 Module
module "ec2" {
  source = "./modules/ec2"

  project_name  = var.project_name
  environment   = local.environment
  ami_id        = var.ami_id
  instance_type = local.instance_types[local.environment]

  subnet_id = data.terraform_remote_state.networking.outputs.public_subnet_ids[0]

  security_group_ids = [
    data.terraform_remote_state.networking.outputs.ec2_security_group_id
  ]
}

# RDS Module
module "rds" {
  source = "./modules/rds"

  project_name = var.project_name
  environment  = local.environment

  subnet_ids = data.terraform_remote_state.networking.outputs.private_subnet_ids

  security_group_ids = [
    data.terraform_remote_state.networking.outputs.rds_security_group_id
  ]

  instance_class    = local.db_instance_classes[local.environment]
  allocated_storage = 20
  engine_version    = var.engine_version

  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}

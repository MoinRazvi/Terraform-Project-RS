variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "terraform-lab"
}

variable "ami_id" {
  description = "Valid AMI ID in the selected AWS region"
  type        = string
}

# variable "ec2_subnet_id" {
#   type = string
# }

# variable "ec2_security_group_ids" {
#   type = list(string)
# }

# variable "rds_subnet_ids" {
#   type = list(string)
# }

# variable "rds_security_group_ids" {
#   type = list(string)
# }

variable "engine_version" {
  type = string
}

variable "db_name" {
  type    = string
  default = "appdb"
}

variable "db_username" {
  type    = string
  default = "dbadmin"
}

variable "db_password" {
  type      = string
  sensitive = true
}

# variable "my_ip_cidr" {
#   description = "Y49.205.119.160/32"
#   type        = string
# }
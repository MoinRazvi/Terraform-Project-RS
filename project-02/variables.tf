variable "aws_region" {
  description = "AWS region for the project"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project resource prefix"
  type        = string
  default     = "project-02"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "subnet_a_cidr" {
  type    = string
  default = "10.20.1.0/24"
}

variable "subnet_b_cidr" {
  type    = string
  default = "10.20.2.0/24"
}
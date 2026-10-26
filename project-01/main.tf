# Terraform configuration for AWS resources
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Find available Availability Zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Find the latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# 1. Create VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "tf-lab-vpc"
    Environment = "Lab"
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [tags["Environment"]]
  }
}

# 2. Create Subnet-A
resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name        = "SUBNET-A"
    Environment = "Lab"
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [tags["Environment"]]
  }
}

# 3. Create Subnet-B
resource "aws_subnet" "subnet_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name        = "SUBNET-B"
    Environment = "Lab"
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [tags["Environment"]]
  }
}

# 4. Security group - no inbound access
resource "aws_security_group" "servers" {
  name        = "tf-lab-sg"
  description = "Security group for Terraform drift lab"
  vpc_id      = aws_vpc.main.id

  # Outbound access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf-lab-sg"
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [tags["Environment"]]
  }
}

# 5. EC2 instance in Subnet-A
resource "aws_instance" "server_a" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.subnet_a.id
  vpc_security_group_ids      = [aws_security_group.servers.id]
  associate_public_ip_address = false

  tags = {
    Name        = "SERVER-A"
    Environment = "Lab"
    Owner       = "TerraformLab"
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [tags["Owner"]]
  }
}

# 6. EC2 instance in Subnet-B
resource "aws_instance" "server_b" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.subnet_b.id
  vpc_security_group_ids      = [aws_security_group.servers.id]
  associate_public_ip_address = false

  tags = {
    Name        = "SERVER-B"
    Environment = "Lab"
    Owner       = "TerraformLab"
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [tags["Owner"]]
  }
}

# AWS Provider Configuration
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
      CreatedBy   = "HCP-Terraform"
    }
  }
}

# Data source to get the default VPC
data "aws_vpc" "default" {
  default = true
}

# Data source to get the default subnet
data "aws_subnet" "default" {
  vpc_id            = data.aws_vpc.default.id
  availability_zone = data.aws_availability_zones.available.names[0]
  default_for_az    = true
}

# Data source to get available availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Data source to get the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security Group for EC2 instance
resource "aws_security_group" "ec2_sg" {
  name_prefix = "${var.project_name}-ec2-"
  description = "Security group for EC2 instance"
  vpc_id      = data.aws_vpc.default.id

  # SSH access
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  # HTTP access
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ec2-sg"
  }
}

# EC2 Instance
resource "aws_instance" "main" {
  count                  = var.instance_count
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  subnet_id              = data.aws_subnet.default.id

  # User data script for basic setup
  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    project_name = var.project_name
  }))

  tags = {
    Name = "${var.project_name}-instance-${count.index + 1}"
  }
}
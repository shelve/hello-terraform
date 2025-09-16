# Instance IDs
output "instance_ids" {
  description = "IDs of the created EC2 instances"
  value       = aws_instance.main[*].id
}

# Instance Public IPs
output "instance_public_ips" {
  description = "Public IP addresses of the EC2 instances"
  value       = aws_instance.main[*].public_ip
}

# Instance Private IPs
output "instance_private_ips" {
  description = "Private IP addresses of the EC2 instances"
  value       = aws_instance.main[*].private_ip
}

# Instance Public DNS Names
output "instance_public_dns" {
  description = "Public DNS names of the EC2 instances"
  value       = aws_instance.main[*].public_dns
}

# Security Group ID
output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.ec2_sg.id
}

# VPC ID
output "vpc_id" {
  description = "ID of the VPC where resources are created"
  value       = data.aws_vpc.default.id
}

# Subnet ID
output "subnet_id" {
  description = "ID of the subnet where instances are created"
  value       = data.aws_subnet.default.id
}

# AMI ID
output "ami_id" {
  description = "ID of the AMI used for the instances"
  value       = data.aws_ami.amazon_linux.id
}
provider "aws" {
  region = "us-east-1"
}

# ========================
# Get default VPC
# ========================
data "aws_vpc" "default" {
  default = true
}

# ========================
# Get default subnets
# ========================
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

locals {
  default_subnet_id = data.aws_subnets.default.ids[0]
}

# ========================
# Security Group
# ========================
resource "aws_security_group" "sg" {
  name   = "demo-sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ========================
# EC2 Instance
# ========================
resource "aws_instance" "jenkins_ec2" {
  ami                    = "ami-052064a798f08f0d3"   # Amazon Linux 2
  instance_type          = "t2.micro"
  key_name               = "newkey_capstone"
  subnet_id              = local.default_subnet_id
  vpc_security_group_ids = [aws_security_group.sg.id]

  user_data = file("../my_terraform/user_data.sh")  # adjust path if needed

  tags = {
    Name = "jenkins-docker-ec2"
  }
}

# ========================
# Outputs
# ========================
output "ec2_public_ip" {
  value       = aws_instance.jenkins_ec2.public_ip
  description = "Public IPv4 of EC2 instance"
}

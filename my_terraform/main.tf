provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-terraform-state-demo-12345"
  acl    = "private"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "demo-vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"
  tags = {
    Name = "demo-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "demo-igw"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "demo-rt"
  }
}

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "sg" {
  name        = "demo-sg"
  description = "Allow SSH, HTTP, Jenkins"
  vpc_id      = aws_vpc.main.id

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

  tags = {
    Name = "demo-sg"
  }
}

resource "aws_instance" "jenkins_ec2" {
  ami                    = "ami-052064a798f08f0d3"
  instance_type          = "t2.micro"
  key_name               = "key_capstone"
  subnet_id              = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.sg.id]

  user_data = file("user_data.sh")

  tags = {
    Name = "jenkins-docker-ec2"
  }
}

output "ec2_public_ip" {
  value       = aws_instance.jenkins_ec2.public_ip
  description = "Public IPv4 of EC2 instance"
}

output "s3_bucket_name" {
  value       = aws_s3_bucket.terraform_state.id
  description = "Terraform state S3 bucket"
}

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

//VPC
resource "aws_vpc" "dev_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "DEV-VPC"
  }
}

//Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public-Subnet"
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false
  tags = {
    Name = "Private-Subnet"
  }
}
//internet gateway
resource "aws_internet_gateway" "dev_igw" {
  vpc_id = aws_vpc.dev_vpc.id
  tags = {
    name = "dev_igw"
  }
  
}
//public route table 
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.dev_vpc.id
  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_igw.id
  }

  tags = {
    name = "public_rt"
  }
}
resource "aws_route_table_association" "public_assoc" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
//nat agteway

resource "aws_eip" "nat_eip" {
  domain = "vpc"  
}
resource "aws_nat_gateway" "dev_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public_subnet.id
  tags = {
    name = "dev-nat"
  }
  depends_on = [ aws_internet_gateway.dev_igw ]
}
//private route table 
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.dev_vpc.id
  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_igw.id
  }

  tags = {
    name = "private_rt"
  }
}
resource "aws_route_table_association" "private_assoc" {
  subnet_id = aws_subnet.priavte_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

# Security Group for Public (Jenkins + Proxy)
resource "aws_security_group" "public_sg" {
  name        = "public-SG"
  description = "Allow HTTP/HTTPS/Jenkins"
  vpc_id      = aws_vpc.dev_vpc.id

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

# Security Group for Private (Dev Server)
resource "aws_security_group" "private_sg" {
  name        = "private-SG"
  description = "Allow internal dev ports"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port   = 3001
    to_port     = 3002
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Jenkins Server (Public Subnet)
resource "aws_instance" "jenkins_server" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 (us-east-1)
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]

  tags = {
    Name = "Jenkins-Server"
  }
}

# Proxy Server (Public Subnet)
resource "aws_instance" "proxy_server" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]

  tags = {
    Name = "Proxy-Server"
  }
}

# Dev Server (Private Subnet)
resource "aws_instance" "dev_server" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]

  tags = {
    Name = "Dev-Server"
  }
}

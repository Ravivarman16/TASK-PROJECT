#Provider resource details:
provider "aws" {
  region     = var.zone
  access_key = var.ak
  secret_key = var.sk
}

#Creating the Vpc:
resource "aws_vpc" "taskvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "taskvpc"
  }
}
#Creating the internet gateway:
resource "aws_internet_gateway" "taskigw" {
  vpc_id = aws_vpc.taskvpc.id

  tags = {
    Name = "taskigw"
  }
}
#creating the subnet2:
resource "aws_subnet" "tasksubnet" {
  vpc_id     = aws_vpc.taskvpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "tasksubnet"
  }
}
#creating the route table:
resource "aws_route_table" "taskroute_table" {
  vpc_id = aws_vpc.taskvpc.id
  tags = {
    Name = "task_route_table"
  }
}
#associating route internet gateway in route table:
resource "aws_route" "task_routing" {
  route_table_id         = aws_route_table.taskroute_table.id
  destination_cidr_block = "0.0.0.0/0" # Route all traffic to the Internet Gateway
  gateway_id             = aws_internet_gateway.taskigw.id
}
#creating the subnet association with the route table:
resource "aws_route_table_association" "subnet_association" {
  subnet_id      = aws_subnet.tasksubnet.id
  route_table_id = aws_route_table.taskroute_table.id
}
#creating the security group:
resource "aws_security_group" "tasksc" {
  name        = "tasksc"
  description = "security group for AWS EC2 instances"
  vpc_id      = aws_vpc.taskvpc.id
  # Ingress rules (inbound traffic)
  # Allow SSH (port 22) from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP (port 80) from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Allow HTTPS (port 443) from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Allow CUSTOM TCP (port 8080) from anywhere
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow CUSTOM TCP (port 30009) for NodePort service for accessing from anywhere
  ingress {
    from_port   = 30009
    to_port     = 30009
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rules (outbound traffic)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tasksc"
  }
}
#creating the instance:
resource "aws_instance" "server" {
  count                  = "5"
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.tasksubnet.id
  key_name               = var.key
  vpc_security_group_ids = [aws_security_group.tasksc.id]
  associate_public_ip_address = true
  tags = {
    Name = "task - ${count.index}"
  }
}

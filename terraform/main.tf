########################
# VPC
########################

resource "aws_vpc" "main" {

  cidr_block           = "10.0.0.0/16"

  enable_dns_support   = true

  enable_dns_hostnames = true

  tags = {
    Name = "ansible-vpc"
  }

}

########################
# Internet Gateway
########################

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "ansible-igw"
  }

}

########################
# Public Subnet
########################

resource "aws_subnet" "public" {

  vpc_id                  = aws_vpc.main.id

  cidr_block              = "10.0.1.0/24"

  availability_zone       = var.availability_zone

  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }

}

########################
# Route Table
########################

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw.id

  }

  tags = {
    Name = "public-route-table"
  }

}

resource "aws_route_table_association" "public" {

  subnet_id      = aws_subnet.public.id

  route_table_id = aws_route_table.public.id

}

########################
# Key Pair
########################

resource "aws_key_pair" "ansible" {

  key_name   = var.key_name

  public_key = file(var.public_key_path)

}

########################
# Security Group
########################

resource "aws_security_group" "ansible" {

  name = "ansible-security-group"

  vpc_id = aws_vpc.main.id

  ingress {

    description = "SSH"

    from_port = 22

    to_port = 22

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {

    description = "HTTP"

    from_port = 80

    to_port = 80

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "ansible-security-group"
  }

}

########################
# Control Node
########################

resource "aws_instance" "control_node" {

  ami                    = var.ami_id

  instance_type          = var.instance_type

  subnet_id              = aws_subnet.public.id

  key_name               = aws_key_pair.ansible.key_name

  vpc_security_group_ids = [aws_security_group.ansible.id]

  tags = {

    Name = "ansible-control-node"

  }

}

########################
# Managed Nodes
########################

resource "aws_instance" "managed_nodes" {

  count = 2

  ami                    = var.ami_id

  instance_type          = var.instance_type

  subnet_id              = aws_subnet.public.id

  key_name               = aws_key_pair.ansible.key_name

  vpc_security_group_ids = [aws_security_group.ansible.id]

  tags = {

    Name = "managed-node-${count.index + 1}"

  }

}

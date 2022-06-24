provider "aws" {
  region     = "us-east-1"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    name        = "name"
    environment = "environment"
  }
}

#### PRIVATE SUBNETS
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id
  for_each          = var.private_subnet_numbers
  cidr_block        = cidrsubnet(aws_vpc.my_vpc.cidr_block, 4, each.value)
  availability_zone = each.key

  tags = {
    name        = "name"
    environment = "environment"
  }
}


#### PUBLIC SUBNETS
resource "aws_subnet" "public_subnets" {
  vpc_id            = aws_vpc.my_vpc.id
  for_each          = var.public_subnet_numbers
  cidr_block        = cidrsubnet(aws_vpc.my_vpc.cidr_block, 4, each.value)
  availability_zone = each.key

  tags = {
    name        = "name"
    environment = "environment"
  }
}

resource "aws_network_acl" "private" {
  vpc_id   = aws_vpc.my_vpc.id
  for_each = var.private_subnet_numbers

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = cidrsubnet(aws_vpc.my_vpc.cidr_block, 4, each.value)
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = cidrsubnet(aws_vpc.my_vpc.cidr_block, 4, each.value)
    from_port  = 80
    to_port    = 80
  }

  tags = {
    name        = "name"
    environment = "environment"
  }
}

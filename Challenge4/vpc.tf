terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.19.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-2"
}

data "aws_availability_zones" "available" {
  state = "available"
}


resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "LJ-vpc"
  }

}

resource "aws_subnet" "private" {
  count                   = 2
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
  cidr_block              = "10.0.${count.index}.0/24"
  tags = {
    Name = "LJ-private-subnet"
  }
}

resource "aws_subnet" "public" {
  count                   = 2
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
  cidr_block              = "10.0.${count.index + 2}.0/24"
  tags = {
    Name = "LJ-public-subnet"
  }

}




resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id


  tags = {
    Name = "LJroutetable"
  }
}

resource "aws_route_table" "main2" {
  vpc_id = aws_vpc.main.id


  tags = {
    Name = "LJroutetable2"
  }
}

resource "aws_route_table" "to_IGW" {
  vpc_id = aws_vpc.main.id


  tags = {
    Name = "LJroutetable-IGW"
  }
}

resource "aws_internet_gateway" "igw1" {
  vpc_id = aws_vpc.main.id
}

resource "aws_nat_gateway" "gw1" {
  subnet_id     = aws_subnet.public[0].id
  allocation_id = aws_eip.nat_eip.id

  tags = {
    Name = "NAT_for_workers_1"
  }
}

resource "aws_nat_gateway" "gw2" {
  subnet_id     = aws_subnet.public[1].id
  allocation_id = aws_eip.nat_eip2.id

  tags = {
    Name = "NAT_for_workers_2"
  }
}


resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_eip" "nat_eip2" {
  vpc = true
}


resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.private[0].id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.private[1].id
  route_table_id = aws_route_table.main2.id
}


resource "aws_route_table_association" "gate_to_nat" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.to_IGW.id
}

resource "aws_route" "igwroute" {
  route_table_id         = aws_route_table.to_IGW.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw1.id
}


resource "aws_route" "nat_gateway_route" {
  route_table_id         = aws_route_table.main.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.gw1.id
}

resource "aws_route" "nat_gateway_route2" {
  route_table_id         = aws_route_table.main2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.gw2.id
}


resource "aws_security_group" "LJtestSG" {
  vpc_id = aws_vpc.main.id
  name   = "LJsg"

  dynamic "ingress" {
    for_each = var.sg_rules_ingress
    content {
      to_port     = ingress.value["to_port"]
      from_port   = ingress.value["from_port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }

  dynamic "egress" {
    for_each = var.sg_rules_egress
    content {
      to_port     = egress.value["to_port"]
      from_port   = egress.value["from_port"]
      protocol    = egress.value["protocol"]
      cidr_blocks = egress.value["cidr_blocks"]
    }
  }
}

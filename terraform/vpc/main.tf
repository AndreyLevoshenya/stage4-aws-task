resource "aws_vpc" "this" {
  cidr_block = local.vpc_cidr

  tags = {
    Name = "${local.project_name}-VPC"
  }
}

resource "aws_subnet" "public_subnets" {
  vpc_id = aws_vpc.this.id
  count = length(var.public_subnet_cidrs)
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]


  tags = {
    Name = "${local.project_name}-Public-Subnet-${local.az_letters[count.index]}"
  }
}

resource "aws_subnet" "private_subnets" {
  vpc_id = aws_vpc.this.id
  count = length(var.private_subnet_cidrs)
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "${local.project_name}-Private-Subnet-${local.az_letters[count.index]}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${local.project_name}-Internet-Gateway"
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${local.project_name}-Public-Route_Table"
  }
}

resource "aws_route_table_association" "public-subnet-assoc" {
  count = length(var.public_subnet_cidrs)
  subnet_id = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_eip" "nat_eip" {
  count = length(var.public_subnet_cidrs)
  domain = "vpc"

  tags = {
    Name = "${local.project_name}-EIP-${local.az_letters[count.index]}"
  }
}

resource "aws_nat_gateway" "nat" {
  count = length(var.public_subnet_cidrs)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id = aws_subnet.public_subnets[count.index].id

  tags = {
    Name = "${local.project_name}-NAT-${local.az_letters[count.index]}"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private-rt" {
  count = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }

  tags = {
    Name = "${local.project_name}-Private-Route-Table-${local.az_letters[count.index]}"
  }
}

resource "aws_route_table_association" "private-subnet-assoc" {
  count = length(var.private_subnet_cidrs)
  subnet_id = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private-rt[count.index].id
}




output "vpc" {
  description = "VPC information"
  value = {
    id   = aws_vpc.this.id
    cidr = local.vpc_cidr
    name = local.project_name
  }
}

output "vpc_public_subnets" {
  description = "Public subnets with IDs, CIDR blocks and AZs"
  value       = [
    for idx, subnet in aws_subnet.public_subnets : {
      id                = subnet.id
      cidr              = var.public_subnet_cidrs[idx]
      availability_zone = var.azs[idx]
      route_table_id    = aws_route_table.public_rt.id
      nat_gateway_id    = aws_nat_gateway.nat[idx].id
      name              = "${local.project_name}-Public-Subnet-${local.az_letters[idx]}"
    }
  ]
}

output "vpc_private_subnets" {
  description = "Private subnets with IDs, CIDR blocks, AZs and associated NAT gateways"
  value       = [
    for idx, subnet in aws_subnet.private_subnets : {
      id                = subnet.id
      cidr              = var.private_subnet_cidrs[idx]
      availability_zone = var.azs[idx]
      route_table_id    = aws_route_table.private_rt[idx].id
      nat_gateway_id    = aws_nat_gateway.nat[idx].id
      name              = "${local.project_name}-Private-Subnet-${local.az_letters[idx]}"
    }
  ]
}

output "vpc_nat_gateways" {
  description = "NAT Gateway IDs with associated EIP and subnet"
  value       = [
    for idx, nat in aws_nat_gateway.nat : {
      id                = nat.id
      subnet_id         = nat.subnet_id
      eip_allocation_id = aws_eip.nat_eip[idx].id
      name              = "${local.project_name}-NAT-${local.az_letters[idx]}"
    }
  ]
}

output "vpc_internet_gateway" {
  description = "Internet Gateway ID"
  value = {
    id   = aws_internet_gateway.igw.id
    name = "${local.project_name}-Internet-Gateway"
  }
}

output "vpc_route_tables" {
  description = "All route tables in the VPC"
  value = {
    public = {
      id     = aws_route_table.public_rt.id
      name   = "${local.project_name}-Public-Route-Table"
      routes = aws_route_table.public_rt.route[*].cidr_block
    }
    private = [
      for idx, rt in aws_route_table.private_rt : {
        id             = rt.id
        name           = "${local.project_name}-Private-Route-Table-${local.az_letters[idx]}"
        routes         = rt.route[*].cidr_block
        nat_gateway_id = aws_nat_gateway.nat[idx].id
      }
    ]
  }
}
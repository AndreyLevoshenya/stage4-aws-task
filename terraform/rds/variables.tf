variable "private_subnets" {
  description = "Subnets for rds db subnet group"
  type = list(object({
    id                = string
    cidr              = string
    availability_zone = string
    route_table_id    = string
    nat_gateway_id    = string
    name              = string
  }))
}

variable "vpc_id" {}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "bastion_sg_id" {
  type        = string
  description = "Id of bastion host security group to access rds"
}
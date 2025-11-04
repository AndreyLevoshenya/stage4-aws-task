variable "vpc_id" {}

variable "admin_ip" {
  type    = string
  default = "127.0.0.1/32"
}

variable "public_subnets" {
  description = "Subnet where ec2 will be created"
  type = list(object({
    id                = string
    cidr              = string
    availability_zone = string
    route_table_id    = string
    nat_gateway_id    = string
    name              = string
  }))
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  description = "SSH key to access instance"
}

variable "ami_name_filter" {
  description = "Filter to select image of instance"
  type = list(string)
  default = ["amzn2-ami-hvm-*-x86_64-gp2"]
}
module "vpc" {
  source = "./vpc"

  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.azs
}

module "iam" {
  source = "./iam"
}

module "s3" {
  source = "./s3"
}

# module "ec2" {
#   depends_on = [module.vpc, module.iam]
#   source         = "./ec2"
#   vpc_id         = module.vpc.vpc.id
#   public_subnets = module.vpc.vpc_public_subnets
#   key_name = "ec2_key" # should create key in aws account for ssh access
#   iam_ec2_role   = module.iam.s3_full_access_role
#
#   instance_type = "t3.micro"
#   ami_name_filter = ["amzn2-ami-hvm-*-x86_64-gp2"]
#   admin_ip      = "127.0.0.1/32"
# }

module "bastion" {
  depends_on = [module.vpc]
  source         = "./ec2v2"
  vpc_id         = module.vpc.vpc.id
  public_subnets = module.vpc.vpc_public_subnets
  key_name = "ec2_key" # should create key in aws account for ssh access

  instance_type = "t3.micro"
  ami_name_filter = ["amzn2-ami-hvm-*-x86_64-gp2"]
  admin_ip      = "127.0.0.1/32"
}

module "rds" {
  depends_on = [module.vpc, module.bastion]
  source          = "./rds"
  vpc_id          = module.vpc.vpc.id
  private_subnets = module.vpc.vpc_private_subnets
  db_password     = "password"
  bastion_sg_id   = module.bastion.bastion_sg.id
}
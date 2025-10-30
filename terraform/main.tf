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
module "counting_dashboard_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = var.vpc_name
  cidr                 = var.vpc_cidr
  azs                  = var.azs
  enable_dns_hostnames = var.enable_dns_hostnames
  tags                 = var.vpc_tags

  public_subnets     = var.public_subnets
  public_subnet_tags = var.public_subnet_tags

  private_subnets     = var.private_subnets
  private_subnet_tags = var.private_subnet_tags

  create_igw = var.create_igw
  igw_tags   = var.igw_tags

  enable_nat_gateway = true
  single_nat_gateway = var.single_nat_gateway
}
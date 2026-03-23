locals {
  # Inject public_subnets into rules missing cidr_blocks
  dashboard_ingress_with_cidr_blocks = [
    for rule in var.dashboard_ingress_with_cidr_blocks :
    lookup(rule, "cidr_blocks", null) == null
    ? merge(rule, { cidr_blocks = join(",", var.public_subnets) })
    : rule
  ]
  # Inject the dashboard SG ID created by the module
  counting_ingress_with_source_sg = [
    for rule in var.counting_ingress_with_source_sg :
    merge(rule, {
      source_security_group_id = module.dashboard_sg.security_group_id # ← exact key name
    })
  ]
  counting_ingress_with_cidr_blocks = [
    for rule in var.dashboard_ingress_with_cidr_blocks :
    lookup(rule, "cidr_blocks", null) == null
    ? merge(rule, { cidr_blocks = join(",", var.public_subnets) })
    : rule
  ]
}

module "dashboard_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "dashboard-sg"
  description = "Security Group for Dashboard (frontend) allowing HTTP, SSH from my IP range and 8000 for application access"
  vpc_id      = module.counting_dashboard_vpc.vpc_id

  ingress_with_cidr_blocks = local.dashboard_ingress_with_cidr_blocks
  egress_with_cidr_blocks  = var.egress_with_cidr_blocks
}

module "counting_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "counting-sg"
  description = "Security Group for Counting application (backend) SSH and 9000 for application access ONLY from frontend subnet"
  vpc_id      =  module.counting_dashboard_vpc.vpc_id

  ingress_with_cidr_blocks              = local.counting_ingress_with_cidr_blocks
  ingress_with_source_security_group_id = local.counting_ingress_with_source_sg
  egress_with_cidr_blocks               = var.egress_with_cidr_blocks
}
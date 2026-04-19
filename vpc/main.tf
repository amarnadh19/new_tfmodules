resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_blocks
  enable_dns_hostnames = var.enable_dns_hostnames
  instance_tenancy = var.instance_tenancy
  tags = {
    name = join("_",[var.env, var.aws_service, var.org_name])
  }
}

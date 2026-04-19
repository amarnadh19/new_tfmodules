resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_blocks
  enable_dns_hostnames = var.enable_dns_hostnames
  instance_tenancy = var.instance_tenancy
  tags = {
    name = join("_",[var.env, var.aws_service, var.org_name])
  }
}
resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  map_public_ip_on_launch = var.enable_subnet_public_ip

  tags = {
    # This creates a clean tag like "prod-public-1a"
    Name = "${var.env}-${each.key}"
  }
}

resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    # This creates a clean tag like "prod-public-1a"
    Name = "${var.env}-${each.key}"
  }
}


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

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env}-igw"
  }
}

# 1. Create the Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.env}-public-rt"
  }
}

# 2. Associate ALL public subnets to this table
resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# 1. Create the Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  # Note: No 0.0.0.0/0 route yet unless you add a NAT Gateway
  tags = {
    Name = "${var.env}-private-rt"
  }
}
resource "aws_route" "private_nat_route" {
  count                  = var.enable_nat_gateway ? 1 : 0
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main[0].id
}

# 2. Associate ALL private subnets to this table
resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

# 1. Create EIP for NAT (only if enabled)
resource "aws_eip" "nat" {
  count  = var.enable_nat_gateway ? 1 : 0
  domain = "vpc"
  tags   = { Name = "${var.env}-nat-eip" }
}

# 2. Create NAT Gateway (only if enabled)
resource "aws_nat_gateway" "main" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id

  # Pick the first public subnet from your map
  # values() converts the map to a list so we can grab index 0
  subnet_id     = values(aws_subnet.public)[0].id

  tags = { Name = "${var.env}-nat-gw" }

  # To ensure proper ordering, it must depend on the IGW
  depends_on = [aws_internet_gateway.main]
}

# Create the FREE S3 Gateway Endpoint


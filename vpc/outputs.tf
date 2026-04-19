output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_details" {
  value = {
    for k, s in aws_subnet.public: k => {
      id   = s.id
      cidr = s.cidr_block
      az   = s.availability_zone
    }
  }
}

output "private_subnet_details" {
  value = {
    for k, s in aws_subnet.private: k => {
      id   = s.id
      cidr = s.cidr_block
      az   = s.availability_zone
    }
  }
}

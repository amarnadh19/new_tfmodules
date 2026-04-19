variable "vpc_cidr_blocks" {}
variable "env" {}
variable "org_name" {

}

variable "aws_service" {
  default = "vpc"
  description = "aws service name"
}

variable "instance_tenancy" {
  default = "default"
}

variable "enable_dns_hostnames" {
  default = true
}

variable "public_subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))
  default = {
    "public-1a" = { cidr = "10.0.1.0/24", az = "ap-south-1a" }
    "public-1b" = { cidr = "10.0.2.0/24", az = "ap-south-1b" }
  }
}
variable "private_subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))
  default = {
    "public-1a" = { cidr = "10.0.10.0/24", az = "ap-south-1a" }
    "public-1b" = { cidr = "10.0.11.0/24", az = "ap-south-1b" }
  }
}
variable "enable_subnet_public_ip" {
  default = true
}
variable "enable_nat_gateway" {
  description = "If true, a NAT Gateway will be created for private subnets"
  type        = bool
  default     = false
}

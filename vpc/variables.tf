variable "vpc_cidr_blocks" {}
variable "env" {}
variable "org_name" {

}

variable "aws_service" {
  default = "vpc"
}

variable "instance_tenancy" {
  default = "default"
}

variable "enable_dns_hostnames" {
  default = true
}

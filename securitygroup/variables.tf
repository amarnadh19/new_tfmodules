variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where the SG will be created"
}

variable "env" {
  type    = string
  default = "dev"
}

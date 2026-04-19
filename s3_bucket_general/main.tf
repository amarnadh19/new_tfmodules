locals {
  bucket_name = join("-",[var.env, var.aws_service, var.org_name])
}

resource "aws_s3_bucket" "main" {
  bucket = local.bucket_name
  tags = {
    Name = local.bucket_name
  }
}

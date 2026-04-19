resource "aws_ecr_repository" "worker" {
  name                 = "${var.env}-${var.org_name}-worker"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false # Automatically checks for vulnerabilities
  }
}

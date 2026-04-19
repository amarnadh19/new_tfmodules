resource "aws_security_group" "ecs_tasks" {
  name        = "${var.env}-ecs-tasks-sg"
  description = "Allow outbound traffic for ECS tasks to reach AWS APIs"
  vpc_id      = var.vpc_id

  # Inbound: Usually empty for a worker that only pulls from SQS
  # If you add an ALB later, you would add an ingress rule here.

  # Outbound: Required to reach ECR, S3, and SQS
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-ecs-tasks-sg"
  }
}


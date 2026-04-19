resource "aws_ecs_cluster" "main" {
  name = "${var.env}-video-cluster"
}

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.env}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })
}

# Granting permission to S3 and SQS as per your diagram
#resource "aws_iam_role_policy" "worker_permissions" {
#  role = aws_iam_role.ecs_task_role.id
#  policy = jsonencode({
#    Version = "2012-10-17"
#    Statement = [
#      {
#        Effect   = "Allow"
#        Action   = ["sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"]
#        Resource = var.sqs_arn
#      },
#      {
#        Effect   = "Allow"
#        Action   = ["s3:GetObject", "s3:PutObject"]
#        Resource = ["${var.input_bucket_arn}/*", "${var.output_bucket_arn}/*"]
#      }
#    ]
#  })
#}

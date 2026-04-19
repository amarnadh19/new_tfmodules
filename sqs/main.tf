resource "aws_sqs_queue" "video_queue" {
  name                        = "${var.env}-video-processing-queue"
  visibility_timeout_seconds  = var.visibility_timeout_seconds # Should be longer than your ECS worker processing time
  message_retention_seconds   = var.message_retention_seconds # 1 day
}

resource "aws_sqs_queue_policy" "s3_to_sqs_policy" {
  queue_url = aws_sqs_queue.video_queue.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "s3.amazonaws.com" }
        Action    = "sqs:SendMessage"
        Resource  = aws_sqs_queue.video_queue.arn
        Condition = {
          ArnLike = { "aws:SourceArn" : "${var.s3arn}" }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.s3id # This is your existing input bucket

  queue {
    queue_arn     = aws_sqs_queue.video_queue.arn
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".mp4" # Only trigger for videos
  }

  # This ensures the policy is created before the notification tries to verify it
  depends_on = [aws_sqs_queue_policy.s3_to_sqs_policy]
}

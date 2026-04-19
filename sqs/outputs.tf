output "sqs_url" {
  value = aws_sqs_queue.video_queue.url
}

output "sqs_arn" {
  value = aws_sqs_queue.video_queue.arn
}

outut "sql_name" {
  value= aws_sqs_queue.video_queue.name
}

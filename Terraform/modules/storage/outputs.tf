output "images_bucket_arn" {
  description = "ARN of the Images S3 bucket"
  value       = aws_s3_bucket.cf_testbucket1
}

output "logs_bucket_arn" {
  description = "ARN of the Logs S3 bucket"
  value       = aws_s3_bucket.cf_testbucket2
}
output "bucket_name" {
  description = "S3 Bucket Name"
  value       = aws_s3_bucket.website.bucket
}

output "bucket_arn" {
  description = "S3 Bucket ARN "
  value       = aws_s3_bucket.website.arn
}

output "bucket_region" {
  description = "S3 Bucket Region"
  value       = aws_s3_bucket.website.region
}

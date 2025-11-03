output "s3_full_access_role" {
  value = aws_iam_role.full_access_role_s3.name
}

output "s3_full_access_role_arn" {
  value = aws_iam_role.full_access_role_s3.arn
}
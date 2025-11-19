resource "aws_iam_role" "lambda_s3_read_dynamodb_write_role" {
  name = "lambda_s3_read_dynamodb_write_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "s3_read_policy" {
  name        = "ReadAccessPolicyS3"
  description = "Allows Lambda to read CSV files from S3"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["s3:GetObject"],
        Resource = [
          format("arn:aws:s3:::%s/*", var.bucket_name)
        ]
      },
      {
        Effect = "Allow",
        Action = ["s3:ListBucket"],
        Resource = format("arn:aws:s3:::%s", var.bucket_name)
      }
    ]
  })
}

resource "aws_iam_policy" "dynamodb_write_policy" {
  name        = "WriteAccessPolicyDynamoDb"
  description = "Allows Lambda to write to DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:PutItem",
          "dynamodb:BatchWriteItem",
          "dynamodb:UpdateItem",
          "dynamodb:DescribeTable"
        ],
        Resource = [
          var.dynamodb_table.arn,
          "${var.dynamodb_table.arn}/index/*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_logging_policy" {
  name        = "LambdaLoggingPolicy"
  description = "Allows Lambda to write logs to CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_s3_read_attach" {
  policy_arn = aws_iam_policy.s3_read_policy.arn
  role       = aws_iam_role.lambda_s3_read_dynamodb_write_role.name
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb_write_attach" {
  policy_arn = aws_iam_policy.dynamodb_write_policy.arn
  role       = aws_iam_role.lambda_s3_read_dynamodb_write_role.name
}

resource "aws_iam_role_policy_attachment" "lambda_log_attach" {
  policy_arn = aws_iam_policy.lambda_logging_policy.arn
  role       = aws_iam_role.lambda_s3_read_dynamodb_write_role.name
}
data "archive_file" "s3_to_dynamodb_py" {
  type        = "zip"
  source_file = "${path.module}/lambda_py/s3ToDynamoDbFunction.py"
  output_path = "${path.module}/lambda_py/lambda.zip"
}

resource "aws_lambda_function" "s3_to_dynamodb_function" {
  filename         = data.archive_file.s3_to_dynamodb_py.output_path
  function_name    = "s3_to_dynamodb_function"
  role             = aws_iam_role.lambda_s3_read_dynamodb_write_role.arn
  handler          = "s3ToDynamoDbFunction.lambda_handler"
  source_code_hash = data.archive_file.s3_to_dynamodb_py.output_base64sha256

  runtime = "python3.11"

  timeout     = 30
  memory_size = 256
}
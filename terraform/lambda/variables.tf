variable "bucket_name" {
  type = string
}

variable "dynamodb_table" {
  type = object({
    arn = string
    name = string
    id = string
  })
}
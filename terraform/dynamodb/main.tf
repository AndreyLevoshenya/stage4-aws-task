resource "aws_dynamodb_table" "fleet-table" {
  name         = "${local.project_name}-Fleet"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "registry"
  range_key    = "name"

  attribute {
    name = "registry"
    type = "S"
  }

  attribute {
    name = "name"
    type = "S"
  }

  attribute {
    name = "ship_class"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = true
  }

  global_secondary_index {
    name            = "NameRegistryIndex"
    hash_key        = "name"
    range_key       = "registry"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "NameShipClassIndex"
    hash_key        = "name"
    range_key       = "ship_class"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "ShipClassIndex"
    hash_key        = "ship_class"
    projection_type = "ALL"
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "${local.project_name}-Fleet"
    Environment = "localstack"
  }

  timeouts {
    update = "10m"
  }
}

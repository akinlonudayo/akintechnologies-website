resource "aws_dynamodb_table" "contact_messages" {
  name         = "ContactMessages"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "messageId"

  attribute {
    name = "messageId"
    type = "S"
  }
}
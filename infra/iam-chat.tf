# DynamoDB table for chat history (separate from your contact_messages table)
resource "aws_dynamodb_table" "chat_history" {
  name         = "ai-chat-history"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "sessionId"

  attribute {
    name = "sessionId"
    type = "S"
  }

  # Auto-expire sessions after 24 hours
  ttl {
    attribute_name = "ttl"
    enabled        = true
  }
}

# Separate IAM role for the chat Lambda (least privilege)
resource "aws_iam_role" "chat_lambda_role" {
  name = "chat-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

# Basic Lambda execution (CloudWatch logs)
resource "aws_iam_role_policy_attachment" "chat_lambda_basic" {
  role       = aws_iam_role.chat_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# DynamoDB read/write for chat history table only
resource "aws_iam_role_policy" "chat_dynamodb" {
  name = "chat-dynamodb-policy"
  role = aws_iam_role.chat_lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "dynamodb:GetItem",
        "dynamodb:PutItem"
      ]
      Resource = aws_dynamodb_table.chat_history.arn
    }]
  })
}

# Amazon Bedrock - invoke Claude 3 Sonnet only
resource "aws_iam_role_policy" "chat_bedrock" {
  name = "chat-bedrock-policy"
  role = aws_iam_role.chat_lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = ["bedrock:InvokeModel"]
      Resource = "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-3-sonnet-20240229-v1:0"
    }]
  })
}

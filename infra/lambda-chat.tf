# Package the AI chat Lambda from the lambda-chat folder
data "archive_file" "chat_lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda-chat"
  output_path = "${path.module}/lambda-chat.zip"
}

resource "aws_lambda_function" "ai_chat" {
  filename         = data.archive_file.chat_lambda_zip.output_path
  source_code_hash = data.archive_file.chat_lambda_zip.output_base64sha256
  function_name    = "aiChatHandler"
  role             = aws_iam_role.chat_lambda_role.arn
  handler          = "index.handler"
  runtime          = "nodejs22.x"   # matches your existing Lambda runtime
  timeout          = 30             # Bedrock needs more time than contact form
  memory_size      = 256

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.chat_history.name
      BEDROCK_MODEL  = "anthropic.claude-3-sonnet-20240229-v1:0"
    }
  }
}

# CloudWatch logs with 7-day retention
resource "aws_cloudwatch_log_group" "ai_chat_logs" {
  name              = "/aws/lambda/${aws_lambda_function.ai_chat.function_name}"
  retention_in_days = 7
}

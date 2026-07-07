# ── AI Chat Outputs ──

output "chat_api_url" {
  description = "Full URL for the POST /chat endpoint — paste this into chat.html API_URL"
  value       = "${aws_apigatewayv2_api.contact_api.api_endpoint}/chat"
}

output "chat_lambda_name" {
  description = "AI chat Lambda function name"
  value       = aws_lambda_function.ai_chat.function_name
}

output "chat_dynamodb_table" {
  description = "DynamoDB table storing chat history"
  value       = aws_dynamodb_table.chat_history.name
}

output "chat_cloudwatch_logs" {
  description = "CloudWatch log group for debugging Lambda"
  value       = aws_cloudwatch_log_group.ai_chat_logs.name
}

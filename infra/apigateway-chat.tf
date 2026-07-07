# Add /chat route to your existing contact_api HTTP API
resource "aws_apigatewayv2_integration" "ai_chat" {
  api_id                 = aws_apigatewayv2_api.contact_api.id
  integration_type       = "AWS_PROXY"
  integration_method     = "POST"
  integration_uri        = aws_lambda_function.ai_chat.arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "ai_chat" {
  api_id    = aws_apigatewayv2_api.contact_api.id
  route_key = "POST /chat"
  target    = "integrations/${aws_apigatewayv2_integration.ai_chat.id}"
}

# Allow the existing API Gateway to invoke the new chat Lambda
resource "aws_lambda_permission" "api_gateway_chat" {
  statement_id  = "AllowAPIGatewayInvokeChat"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ai_chat.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.contact_api.execution_arn}/*/*"
}

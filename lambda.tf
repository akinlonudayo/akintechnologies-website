   resource "aws_lambda_function" "contact_form" {
     filename      = "lambda.zip"
     function_name = "contactFormHandler"
     role          = aws_iam_role.lambda_role.arn
     handler       = "index.handler"
     runtime       = "nodejs22.x"
     timeout       = 3
     memory_size   = 128

     environment {
       variables = {
         TABLE_NAME = aws_dynamodb_table.contact_messages.name
       }
     }
   }
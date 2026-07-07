#!/bin/bash

# S3 Resources
terraform import aws_s3_bucket.website akintechnologies.com
terraform import aws_s3_bucket_website_configuration.website akintechnologies.com
terraform import aws_s3_bucket_public_access_block.website akintechnologies.com
terraform import aws_s3_bucket_server_side_encryption_configuration.website akintechnologies.com
terraform import aws_s3_bucket_policy.website akintechnologies.com

# CloudFront Resources
terraform import aws_cloudfront_origin_access_control.website E4SUYHVVCQV45
terraform import aws_cloudfront_distribution.website E3T7GRCT0U7GJO

# DynamoDB
terraform import aws_dynamodb_table.contact_messages ContactMessages

# IAM Resources
terraform import aws_iam_role.lambda_role contactFormHandler-role-pz6rcsc3
terraform import aws_iam_policy.lambda_logging arn:aws:iam::409263326615:policy/service-role/AWSLambdaBasicExecutionRole-6485f28c-7669-4223-9538-77a27f5ffd26
terraform import aws_iam_role_policy.lambda_ses contactFormHandler-role-pz6rcsc3:ses
terraform import aws_iam_role_policy_attachment.lambda_logging contactFormHandler-role-pz6rcsc3/arn:aws:iam::409263326615:policy/service-role/AWSLambdaBasicExecutionRole-6485f28c-7669-4223-9538-77a27f5ffd26
terraform import aws_iam_role_policy_attachment.lambda_dynamodb contactFormHandler-role-pz6rcsc3/arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess

# Lambda
terraform import aws_lambda_function.contact_form contactFormHandler
# Skip lambda_permission - will be created by Terraform

# API Gateway v2
terraform import aws_apigatewayv2_api.contact_api 8vj6dojs5d
terraform import aws_apigatewayv2_integration.lambda 8vj6dojs5d/217gtrp
terraform import aws_apigatewayv2_route.contact 8vj6dojs5d/arw6h7s
terraform import aws_apigatewayv2_stage.default 8vj6dojs5d/\$default

# SES
terraform import aws_ses_email_identity.sender akinlonudayo@gmail.com

#!/bin/bash

# Remove duplicate resources from state
terraform state rm aws_cloudfront_distribution.cdn
terraform state rm aws_cloudfront_origin_access_control.oac
terraform state rm aws_dynamodb_table.my_table
terraform state rm aws_iam_role.lambda_exec_role
terraform state rm aws_lambda_function.my_lambda
terraform state rm aws_s3_bucket.site

echo "Duplicates removed from state"

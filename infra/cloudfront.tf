resource "aws_cloudfront_origin_access_control" "website" {
  provider                          = aws.us_east_1
  name                              = "akintechnologies-oac"
  description                       = "Allows CloudFront to read private S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "website" {
  provider            = aws.us_east_1
  enabled             = true
  comment             = "business website"
  aliases             = ["akintechsolutions.com", "www.akintechsolutions.com"]
  default_root_object = "index.html"
  price_class         = "PriceClass_All"
  is_ipv6_enabled     = true
  http_version        = "http2"
  web_acl_id          = "arn:aws:wafv2:us-east-1:409263326615:global/webacl/CreatedByCloudFront-c67fa76b/77e76d47-b129-44db-94ed-07abfe896124"

  origin {
    domain_name              = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id                = "akintechnologies.com.s3-website.ca-central-1.amazonaws.com-mja69rc822a"
    origin_access_control_id = aws_cloudfront_origin_access_control.website.id
  }

  default_cache_behavior {
    target_origin_id       = "akintechnologies.com.s3-website.ca-central-1.amazonaws.com-mja69rc822a"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  }

  viewer_certificate {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:409263326615:certificate/04f61ad5-0fa5-4405-a59e-ae9c77175ea0"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id

  policy = jsonencode({
    Version = "2008-10-17"
    Id      = "PolicyForCloudFrontPrivateContent"
    Statement = [{
      Sid    = "AllowCloudFrontServicePrincipal"
      Effect = "Allow"
      Principal = {
        Service = "cloudfront.amazonaws.com"
      }
      Action   = "s3:GetObject"
      Resource = "${aws_s3_bucket.website.arn}/*"
      Condition = {
        StringEquals = {
          "AWS:SourceArn" = aws_cloudfront_distribution.website.arn
        }
      }
    }]
  })
}
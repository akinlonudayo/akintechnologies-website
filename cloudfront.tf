resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "akintechnologies-oac"
  description                       = "Allows CloudFront to read private S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "cdn" {
  enabled         = true
  is_ipv6_enabled = true

  comment             = "business website"
  default_root_object = "index.html"

  aliases = [
    "akintechsolutions.com",
    "www.akintechsolutions.com",
  ]

  web_acl_id = "arn:aws:wafv2:us-east-1:409263326615:global/webacl/CreatedByCloudFront-c67fa76b/77e76d47-b129-44db-94ed-07abfe896124"

  origin {
    domain_name              = "akintechnologies.com.s3.ca-central-1.amazonaws.com"
    origin_id                = "akintechnologies.com.s3-website.ca-central-1.amazonaws.com-mja69rc822a"
    origin_access_control_id = "E4SUYHVVCQV45"
  }

  default_cache_behavior {
    target_origin_id       = "akintechnologies.com.s3-website.ca-central-1.amazonaws.com-mja69rc822a"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    compress = true

    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = "arn:aws:acm:us-east-1:409263326615:certificate/04f61ad5-0fa5-4405-a59e-ae9c77175ea0"
    ssl_support_method  = "sni-only"
  }

  lifecycle {
    ignore_changes = [
      viewer_certificate,
    ]
  }

  tags = {
    Name = "cloudbusiness"
  }
}

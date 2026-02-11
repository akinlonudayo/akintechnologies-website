resource "aws_acm_certificate" "cert" {
  provider = aws.use1

  # Placeholder values — import will attach state.
  domain_name       = "akintechsolutions.com"
  validation_method = "DNS"
}
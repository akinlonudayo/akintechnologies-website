resource "aws_route53_record" "rootA" {
  zone_id = "Z07839171TGPEEXA9IK15"
  name    = "akintechsolutions.com"
  type    = "A"

  alias {
    name                   = "d3e15nikg1c6ie.cloudfront.net"
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "wwwA" {
  zone_id = "Z07839171TGPEEXA9IK15"
  name    = "www.akintechsolutions.com"
  type    = "A"

  alias {
    name                   = "d3e15nikg1c6ie.cloudfront.net"
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "acm_root_validation" {
  zone_id = "Z07839171TGPEEXA9IK15"
  name    = "_5883d5e6fae68b57d59cd2a46925a8c8.akintechsolutions.com."
  type    = "CNAME"
  ttl     = 300
  records = ["_e4db0d7ad39c13885e26fd951925550a.jkddzztszm.acm-validations.aws."]
}

resource "aws_route53_record" "acm_www_validation" {
  zone_id = "Z07839171TGPEEXA9IK15"
  name    = "_bb086254f0637823ee572b4c95a9db57.www.akintechsolutions.com."
  type    = "CNAME"
  ttl     = 300
  records = ["_ec0c60960cb85a3c4001d6c1861fadd4.jkddzztszm.acm-validations.aws."]
}
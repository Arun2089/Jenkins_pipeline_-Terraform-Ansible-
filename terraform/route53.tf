resource "aws_route53_record" "alb_record" {
  zone_id = "Z01289041WN99TK7TRRUC"
  name    = "jenkinstest.arunlohar.online"  
  type    = "A"

  alias {
    name                   = aws_lb.app_lb.dns_name
    zone_id                = aws_lb.app_lb.zone_id
    evaluate_target_health = true
  }

  ttl = 60  
}

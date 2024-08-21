# Application Load Balancer
resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_alb.id]
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = false
  enable_http2              = true

  tags = {
    Name = "app-lb"
  }
}

# ALB HTTPS Listener
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 443
  protocol          = "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins.arn
  }

  certificate_arn = "arn:aws:acm:ap-south-1:286291623788:certificate/87e58756-beac-4ad6-8930-c3ff109dfa2e" 

  depends_on = [
    aws_lb.app_lb,
    aws_lb_target_group.jenkins
  ]
}

# ALB HTTP Listener with redirection to HTTPS
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      host     = "#{host}"
      path     = "/#{path}"
      port     = "443"
      protocol = "HTTPS"
      query    = "#{query}"
      status_code = "HTTP_301"
    }
  }

  depends_on = [
    aws_lb.app_lb
  ]
}

# Target Group for Jenkins
resource "aws_lb_target_group" "jenkins" {
  name     = "jenkins-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path                = "/login"
    port                = "8080"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold    = 2
    unhealthy_threshold  = 2
  }

  tags = {
    Name = "jenkins-tg"
  }
}

# Attach EC2 instances to the Jenkins Target Group
resource "aws_lb_target_group_attachment" "jenkins_instance_attachment" {
  count              = length(aws_instance.private_instance)
  target_group_arn   = aws_lb_target_group.jenkins.arn
  target_id          = aws_instance.private_instance[count.index].id
  port               = 8080

  depends_on = [
    aws_lb_target_group.jenkins,
    aws_instance.private_instance
  ]
}

# Target Group for React Application
resource "aws_lb_target_group" "app_react" {
  name     = "app-react-tg"
  port     = 8081
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path                = "/"
    port                = "8081"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold    = 2
    unhealthy_threshold  = 2
  }

  tags = {
    Name = "app-react-tg"
  }
}

# Attach EC2 instances to the React Target Group
resource "aws_lb_target_group_attachment" "app_react_instance_attachment" {
  count              = length(aws_instance.private_instance)
  target_group_arn   = aws_lb_target_group.app_react.arn
  target_id          = aws_instance.private_instance[count.index].id
  port               = 8081

  depends_on = [
    aws_lb_target_group.app_react,
    aws_instance.private_instance
  ]
}

# ALB Listener Rule for React Application
resource "aws_lb_listener_rule" "react_rule" {
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_react.arn
  }

  condition {
    field  = "host-header"
    values = ["react.arunlohar.online"]
  }

  listener_arn = aws_lb_listener.https.arn

  depends_on = [
    aws_lb_listener.https,
    aws_lb_target_group.app_react
  ]
}

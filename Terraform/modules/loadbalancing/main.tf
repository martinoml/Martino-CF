resource "aws_lb" "cf_lb" {
  name               = "cf-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = "sg-09a8957e683ba71f6"
  subnets            =  var.subnets

  tags = {
    Name = var.alb_name
   
  }
}
#Create HTTP listener
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.cf_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}
#Create target group for LB
resource "aws_lb_target_group" "my_target_group" {
  name        = "cflb-targetgroup"
  port        = 443
  protocol    = "HTTP"
  vpc_id      = "vpc-012148fbcaa7e6deb"
  target_type = "instance"

  health_check {
    port     = 443
    protocol = "HTTP"
  }

  tags = {
    Name = "cf_lb_target_group"
    // Add other tags as necessary
  }
}

#Listening rules for LB
resource "aws_lb_listener_rule" "https_listener_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }

  condition {
    host_header {
      values = ["example.com"]
    }
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-security-group"
  description = "Security group for ALB"
  vpc_id      = "vpc-012148fbcaa7e6deb"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-security-group"
    // Add other tags as necessary
  }
}
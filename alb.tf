###################################
# ALB CONFIG - PUBLIC ENTRY POINT
###################################

resource "aws_lb" "main" {
  name               = "${var.project_name}-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = false

  tags = {
    Environment = "Testing"
  }
}

#####################################
# ALB LISTENER - REQUESTS ON PORT 80
#####################################

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

#########################
# ALB TARGET GROUP 
#########################

resource "aws_lb_target_group" "web" {
  name     = "web-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

###############################
# ALB TARGET GROUP ATTACHMENT
###############################

resource "aws_lb_target_group_attachment" "web" {
  count = length(aws_instance.web)

  target_group_arn = aws_lb_target_group.web.arn
  target_id        = aws_instance.web[count.index].id
  port             = 80
}
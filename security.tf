#############################
# APPLICATION LOAD BALANCER
#############################

resource "aws_security_group" "alb" {
  name        = "${var.project_name}-alb-sg"
  description = "Allow HTTP from the internet to the Load balancer"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "alb_all_outbound" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports & all protocols
}

####################################
# WEB TIER
####################################

resource "aws_security_group" "web_tier" {
  name        = "${var.project_name}-web-sg"
  description = "Allow HTTP from the ALB to web server"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-web-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "web_tier_http" {
  security_group_id            = aws_security_group.web_tier.id
  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
}

resource "aws_vpc_security_group_egress_rule" "web_tier_all_outbound" {
  security_group_id = aws_security_group.web_tier.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports & all protocols
}
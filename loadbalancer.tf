resource "aws_security_group" "web_public" {
    name = "web_public"
    description = "Allow inbound HTTP traffic on port 80"
    vpc_id = aws_vpc.st-main-1.id

    tags = {
        Name = "web_public"
    }
  
}

resource "aws_vpc_security_group_ingress_rule" "web_public_ipv4" {
    security_group_id = aws_security_group.web_public.id
    cidr_ipv4 = aws_vpc.st-main-1.cidr_block
    from_port = 80
    ip_protocol = "tcp"
    to_port = 80  
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.web_public.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_lb" "web_load_balancer" {
  name = "web-load-balancer"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.web_public.id]
  subnets = [ for subnet in aws_subnet.public_subnets : subnet.id ]
}

resource "aws_lb_target_group" "web_target_group" {
  name = "webserver-target-group"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.st-main-1.id
}

resource "aws_lb_target_group_attachment" "web_target_group_attachment" {
  count = var.web_server_count
  target_group_arn = aws_lb_target_group.web_target_group.arn
  target_id = aws_instance.web[count.index].id
  port = 80
}

resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_load_balancer.arn
  port = "80"
  protocol = "HTTP"
  
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.web_target_group.arn
  }
}
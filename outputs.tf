output "lb_address" {
    value = aws_lb.web_load_balancer.dns_name
}
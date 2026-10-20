###################
# OUTPUTS
###################

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "lb_address" {
  description = "Public DNS name of the Load Balancer"
  value       = aws_lb.main.dns_name
}

output "web_server_public_ips" {
  description = "Public IPs of the individual web servers"
  value       = aws_instance.web[*].public_ip
}
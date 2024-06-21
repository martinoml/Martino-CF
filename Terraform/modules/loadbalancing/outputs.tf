output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.cf_lb
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.cf_lb.dns_name
}
output "alb_dns_name" {
  value       = aws_lb.this.dns_name
  description = "Public DNS name of the ALB."
}

output "alb_security_group_id" {
  value       = aws_security_group.alb.id
  description = "ALB security group ID (allow as ingress source on the task SG)."
}

output "target_group_arn" {
  value       = aws_lb_target_group.this.arn
  description = "Target group ARN the ECS service registers into."
}

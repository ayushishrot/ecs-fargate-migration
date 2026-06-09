output "cluster_name" {
  value       = aws_ecs_cluster.this.name
  description = "ECS cluster name."
}

output "service_name" {
  value       = aws_ecs_service.this.name
  description = "ECS service name."
}

output "task_security_group_id" {
  value       = aws_security_group.task.id
  description = "Security group attached to Fargate tasks."
}

output "task_role_arn" {
  value       = aws_iam_role.task.arn
  description = "Task role ARN (attach app runtime permissions here)."
}

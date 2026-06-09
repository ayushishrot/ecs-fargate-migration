variable "name" {
  type        = string
  description = "Service / cluster name prefix."
}

variable "vpc_id" {
  type        = string
  description = "VPC the service runs in."
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnets for Fargate task ENIs."
}

variable "alb_security_group_id" {
  type        = string
  description = "ALB security group allowed to reach the task port."
}

variable "target_group_arn" {
  type        = string
  description = "ALB target group the service registers into."
}

variable "image" {
  type        = string
  description = "Full container image reference (ECR repo:tag)."
}

variable "release" {
  type        = string
  description = "Release identifier surfaced to the app via env."
  default     = "1.0.0"
}

variable "container_port" {
  type        = number
  description = "Container listen port."
  default     = 8080
}

variable "task_cpu" {
  type        = number
  description = "Fargate task CPU units (256 = 0.25 vCPU)."
  default     = 512
}

variable "task_memory" {
  type        = number
  description = "Fargate task memory (MiB)."
  default     = 1024
}

variable "desired_count" {
  type        = number
  description = "Initial desired task count (autoscaling takes over after apply)."
  default     = 2
}

variable "min_count" {
  type        = number
  description = "Autoscaling minimum task count."
  default     = 2
}

variable "max_count" {
  type        = number
  description = "Autoscaling maximum task count."
  default     = 10
}

variable "cpu_target_value" {
  type        = number
  description = "Target average CPU utilization (%) for scaling."
  default     = 60
}

variable "requests_per_target" {
  type        = number
  description = "Target ALB requests-per-target for scaling."
  default     = 1000
}

variable "alb_request_resource_label" {
  type        = string
  description = "ALB/target-group label for the ALBRequestCountPerTarget metric (app/<alb>/<id>/targetgroup/<tg>/<id>)."
}

variable "log_retention_days" {
  type        = number
  description = "CloudWatch log retention."
  default     = 30
}

variable "secret_arns" {
  type        = list(string)
  description = "Secrets Manager ARNs the execution role may read."
  default     = []
}

variable "secrets" {
  type = list(object({
    name       = string
    value_from = string
  }))
  description = "Container secrets injected from Secrets Manager (name + valueFrom ARN)."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all resources."
  default     = {}
}

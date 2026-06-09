variable "name" {
  type        = string
  description = "Name prefix for ALB/WAF resources."
}

variable "vpc_id" {
  type        = string
  description = "VPC the ALB and target group live in."
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnets for the ALB."
}

variable "container_port" {
  type        = number
  description = "Port the container/target group listens on."
  default     = 8080
}

variable "health_check_path" {
  type        = string
  description = "Target group health check path."
  default     = "/healthz"
}

variable "certificate_arn" {
  type        = string
  description = "ACM certificate ARN for the HTTPS listener."
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all resources."
  default     = {}
}

variable "region" {
  type        = string
  description = "AWS region."
  default     = "ap-south-1"
}

variable "image" {
  type        = string
  description = "Container image to deploy (ECR repo:tag)."
}

variable "release" {
  type        = string
  description = "Release identifier."
  default     = "1.0.0"
}

variable "certificate_arn" {
  type        = string
  description = "ACM certificate ARN for the ALB HTTPS listener."
}

variable "alb_request_resource_label" {
  type        = string
  description = "ALB/target-group resource label for the ALBRequestCountPerTarget scaling metric."
}

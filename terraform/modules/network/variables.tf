variable "name" {
  type        = string
  description = "Name prefix for network resources."
}

variable "cidr_block" {
  type        = string
  description = "VPC CIDR block."
  default     = "10.20.0.0/16"
}

variable "azs" {
  type        = list(string)
  description = "Availability zones to spread subnets across."
}

variable "single_nat_gateway" {
  type        = bool
  description = "Use one shared NAT gateway (cheaper) instead of one per AZ."
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all resources."
  default     = {}
}

variable "project_name" {
  description = "Short name used as a prefix for resource naming."
  type        = string
}

variable "environment" {
  description = "Deployment environment label."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC for the target group."
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for the internet-facing load balancer."
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security group attached to the load balancer."
  type        = string
}

variable "listener_port" {
  description = "TCP port for the HTTP listener (client-facing)."
  type        = number
  default     = 80
}

variable "app_port" {
  description = "TCP port on targets (target group and health check port)."
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "HTTP path for target health checks."
  type        = string
  default     = "/"
}

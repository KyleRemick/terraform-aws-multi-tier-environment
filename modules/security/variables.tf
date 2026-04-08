variable "project_name" {
  description = "Short name used as a prefix for resource naming."
  type        = string
}

variable "environment" {
  description = "Deployment environment label."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where security groups are created."
  type        = string
}

variable "alb_listener_port" {
  description = "TCP port the ALB listens on for inbound traffic from the internet."
  type        = number
  default     = 80
}

variable "app_port" {
  description = "TCP port the application listens on; EC2 accepts traffic from the ALB on this port."
  type        = number
  default     = 80
}

variable "alb_ingress_cidr" {
  description = "IPv4 CIDR allowed to reach the ALB (typically the internet)."
  type        = string
  default     = "0.0.0.0/0"
}

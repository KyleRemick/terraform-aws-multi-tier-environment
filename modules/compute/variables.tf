variable "project_name" {
  description = "Short name used as a prefix for resource naming."
  type        = string
}

variable "environment" {
  description = "Deployment environment label."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for the Auto Scaling Group."
  type        = list(string)
}

variable "ec2_security_group_id" {
  description = "Security group for application instances."
  type        = string
}

variable "target_group_arn" {
  description = "Target group ARN to register instances (ALB)."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
}

variable "app_port" {
  description = "TCP port the application listens on."
  type        = number
  default     = 80
}

variable "asg_min_size" {
  description = "Minimum instances."
  type        = number
}

variable "asg_max_size" {
  description = "Maximum instances."
  type        = number
}

variable "asg_desired_capacity" {
  description = "Desired instance count."
  type        = number
}

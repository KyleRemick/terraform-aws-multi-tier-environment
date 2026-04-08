variable "project_name" {
  description = "Short name used as a prefix for resource naming."
  type        = string
}

variable "environment" {
  description = "Deployment environment label (for example dev, staging, prod)."
  type        = string
}

variable "aws_region" {
  description = "AWS region where resources are created."
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block for the VPC."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (two subnets, one per AZ)."
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "Provide exactly two public subnet CIDR blocks."
  }
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets (two subnets, one per AZ)."
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_cidrs) == 2
    error_message = "Provide exactly two private subnet CIDR blocks."
  }
}

variable "instance_type" {
  description = "EC2 instance type for the Auto Scaling Group."
  type        = string
  default     = "t3.micro"
}

variable "asg_min_size" {
  description = "Minimum number of instances in the Auto Scaling Group."
  type        = number
}

variable "asg_max_size" {
  description = "Maximum number of instances in the Auto Scaling Group."
  type        = number
}

variable "asg_desired_capacity" {
  description = "Desired number of instances in the Auto Scaling Group."
  type        = number

  validation {
    condition     = var.asg_desired_capacity >= var.asg_min_size && var.asg_desired_capacity <= var.asg_max_size
    error_message = "asg_desired_capacity must be between asg_min_size and asg_max_size."
  }
}

variable "app_port" {
  description = "TCP port the application listens on (ALB forwards here)."
  type        = number
  default     = 80
}

variable "alb_health_check_path" {
  description = "HTTP path for the ALB target group health check."
  type        = string
  default     = "/"
}

variable "alb_listener_port" {
  description = "TCP port the internet-facing ALB listener uses (matches security group for ALB)."
  type        = number
  default     = 80
}

variable "common_tags" {
  description = "Optional extra tags applied to supported resources."
  type        = map(string)
  default     = {}
}

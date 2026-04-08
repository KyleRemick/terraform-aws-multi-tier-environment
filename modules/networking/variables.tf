variable "project_name" {
  description = "Short name used as a prefix for resource naming."
  type        = string
}

variable "environment" {
  description = "Deployment environment label."
  type        = string
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block for the VPC."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Two public subnet CIDR blocks (one per AZ)."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Two private subnet CIDR blocks (one per AZ)."
  type        = list(string)
}

output "vpc_id" {
  description = "ID of the provisioned VPC."
  value       = module.networking.vpc_id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC."
  value       = module.networking.vpc_cidr
}

output "public_subnet_ids" {
  description = "Public subnet IDs (ALB and NAT Gateway)."
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs (application tier)."
  value       = module.networking.private_subnet_ids
}

output "availability_zones" {
  description = "Availability zones used for subnets."
  value       = module.networking.availability_zones
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer. Open in a browser to verify HTTP."
  value       = module.alb.alb_dns_name
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer."
  value       = module.alb.alb_arn
}

output "target_group_arn" {
  description = "Target group ARN used by the Auto Scaling Group."
  value       = module.alb.target_group_arn
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group."
  value       = module.compute.autoscaling_group_name
}

output "nat_gateway_id" {
  description = "NAT Gateway ID for private subnet egress."
  value       = module.networking.nat_gateway_id
}

output "ec2_security_group_id" {
  description = "Security group ID for application instances (ingress from ALB only)."
  value       = module.security.ec2_security_group_id
}

output "alb_security_group_id" {
  description = "Security group ID attached to the load balancer."
  value       = module.security.alb_security_group_id
}

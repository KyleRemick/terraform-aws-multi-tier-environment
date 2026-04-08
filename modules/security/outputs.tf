output "alb_security_group_id" {
  description = "Security group attached to the Application Load Balancer."
  value       = aws_security_group.alb.id
}

output "ec2_security_group_id" {
  description = "Security group for EC2 instances (ingress only from ALB)."
  value       = aws_security_group.ec2.id
}

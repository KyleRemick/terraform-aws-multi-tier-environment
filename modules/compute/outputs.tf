output "launch_template_id" {
  description = "ID of the launch template used by the Auto Scaling Group."
  value       = aws_launch_template.app.id
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group."
  value       = aws_autoscaling_group.app.name
}

output "autoscaling_group_arn" {
  description = "ARN of the Auto Scaling Group."
  value       = aws_autoscaling_group.app.arn
}

output "iam_instance_profile_name" {
  description = "Instance profile name attached to application instances."
  value       = aws_iam_instance_profile.ec2.name
}

output "ec2_iam_role_name" {
  description = "IAM role name assumed by EC2 instances."
  value       = aws_iam_role.ec2.name
}

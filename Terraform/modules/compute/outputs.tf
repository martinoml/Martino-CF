# modules/autoscaling/outputs.tf

output "asg_id" {
  description = "ID of the created Auto Scaling Group"
  value       = aws_autoscaling_group.cf_asg
}

output "autoscaling_group_name" {
  description = "Name of the autoscaling group"
  value       = aws_autoscaling_group.cf_asg.name
}

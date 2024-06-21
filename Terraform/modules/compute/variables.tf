# modules/autoscaling/variables.tf

variable "lc_name" {
  description = "Name for the Launch Configuration"
}

variable "instance_type" {
  description = "EC2 instance type for the Launch Configuration"
}



variable "subnet_ids" {
  description = "List of subnet IDs for the Auto Scaling Group"
  type        = list(string)
}

variable "min_size" {
  description = "Minimum size of the Auto Scaling Group"
  type        = number
}

variable "max_size" {
  description = "Maximum size of the Auto Scaling Group"
  type        = number
}

variable "desired_capacity" {
  description = "Desired capacity of the Auto Scaling Group"
  type        = number
}

variable "asg_name" {
  description = "Name of the Auto Scaling Group"
}
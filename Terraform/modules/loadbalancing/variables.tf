variable "alb_name" {
  description = "Name for the Application Load Balancer"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the ALB and ASG are located"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs for the ALB"
  type        = list(string)
}
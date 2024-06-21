# modules/vpc/variables.tf

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
}

variable "vpc_instance_tenancy" {
  description = "Instance tenancy for the VPC"
  default     = "default"
}

variable "vpc_name" {
  description = "Name tag for the VPC"
}

variable "igw_name" {
  description = "Name tag for the Internet Gateway"
}

variable "public_subnets" {
  description = "List of public subnet configurations"
  type        = list(object({
    availability_zone = string
  }))
}

variable "private_subnets" {
  description = "List of private subnet configurations"
  type        = list(object({
    availability_zone = string
  }))
}

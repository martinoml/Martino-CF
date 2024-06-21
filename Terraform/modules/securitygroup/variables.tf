variable "sg_name" {
  description = "Name of the security group"
}

variable "sg_description" {
  description = "Description of the security group"
}

variable "vpc_id" {
  description = "ID of the VPC where the security group will be created"
}

variable "ingress_rules" {
  description = "List of ingress rules for the security group"
  type        = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
}

variable "egress_rules" {
  description = "List of egress rules for the security group"
  type        = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
}




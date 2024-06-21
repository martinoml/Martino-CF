
data "aws_ami" "redhat" {
  most_recent = true

  filter {
    name   = "name"
    values = ["Red Hat Enterprise Linux 8*"]
  }

  owners = ["aws-marketplace"]
}
#Launch Config for ASG
resource "aws_launch_configuration" "cf_lc" {
  name                 = var.lc_name
  image_id             = data.aws_ami.redhat.id
  instance_type        = var.instance_type
  lifecycle {
    create_before_destroy = true
  }
  #script runs on instance launch to install apache web server
   user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              EOF
}

#Create ASG
resource "aws_autoscaling_group" "cf_asg" {
  name                      = var.asg_name
  launch_configuration      = aws_launch_configuration.cf_lc.id
  vpc_zone_identifier       = var.subnet_ids
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  health_check_type         = "EC2"
  health_check_grace_period = 300
  force_delete              = true

  tag {
    key                 = "Name"
    value               = var.asg_name
    propagate_at_launch = true
  }



}
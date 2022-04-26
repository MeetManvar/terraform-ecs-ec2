resource "aws_autoscaling_group" "example" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 2
  max_size           = 2
  min_size           = 1

  launch_template {
    id      = aws_launch_template.example.id
    version = aws_launch_template.example.latest_version
  }
  #launch_configuration= aws_launch_configuration.ecs_launch_config.name
  tag {
    key                 = "Name"
    value               = "Ecs-instance-${var.cluster_name}"
    propagate_at_launch = true
  }
  protect_from_scale_in = true
  lifecycle {
    create_before_destroy = true
  }
  #target_group_arns = ["${aws_lb_target_group.tcw_tg.arn}"]

}

resource "aws_security_group" "sg" {
  name        = "sg1"
  description = "Allow TLS inbound traffic"
  

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    security_groups=["${aws_security_group.my-alb-sg.id}"]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
 
  }
}
# data "aws_ami" "amazon_linux" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["amzn-ami*amazon-ecs-optimized"]
#   }

#   filter {
#     name   = "architecture"
#     values = ["x86_64"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
#   owners = ["amazon", "self"]
# }
resource "aws_launch_template" "example" {
  image_id      = "ami-0dfda8a3ee7678578"
  instance_type = "t2.micro"
  iam_instance_profile{
    arn=aws_iam_instance_profile.ecs_agent.arn
  }
  key_name="meet"
  user_data = base64encode("#!/bin/bash\necho ECS_CLUSTER=${var.cluster_name} >> /etc/ecs/ecs.config")
   #vpc_security_group_ids = ["${aws_security_group.sg.id}"]
   network_interfaces {
    associate_public_ip_address = true
    security_groups =["${aws_security_group.sg.id}"]
  }
}
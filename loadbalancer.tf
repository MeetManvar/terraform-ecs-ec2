
######Load balancer
resource "aws_security_group" "my-alb-sg" {
  name   = "my-alb-sg"
  vpc_id = aws_default_vpc.default.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}


resource "aws_lb" "lb_first" {

  name               = "loadbalancer-ecs"
  load_balancer_type = "application"
  security_groups = [
    "${aws_security_group.my-alb-sg.id}",
  ]
  #subnets = [for s in data.aws_subnet.example : s.id]
  subnets = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
}



resource "aws_lb_listener" "alb_forward_listener" {
  load_balancer_arn = aws_lb.lb_first.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tcw_tg.arn
  }
}

resource "aws_lb_target_group" "tcw_tg" {
  health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    matcher             = "302"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
  name        = "tcw-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_default_vpc.default.id
  target_type = "instance"
}

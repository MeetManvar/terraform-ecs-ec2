resource "aws_ecs_cluster" "foo" {
  name = var.cluster_name
  capacity_providers = [aws_ecs_capacity_provider.test.name]
  # default_capacity_provider_strategy{
  #   capacity_provider=aws_ecs_capacity_provider.test.name
  # }
}

resource "aws_ecs_capacity_provider" "test" {
  name = "test"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.example.arn
    # managed_termination_protection = ""
     managed_termination_protection = "ENABLED"
      managed_scaling {
      status          = "ENABLED"
      target_capacity = 85
    }
  }
  
}

resource "aws_ecs_task_definition" "task-definition-test" {
  family         = "web-family"
  container_definitions = file("./container-def.json")
  network_mode      = "bridge"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  
}

resource "aws_ecs_service" "service" {
  name            = "web-service1"
  cluster         = aws_ecs_cluster.foo.id
  task_definition = aws_ecs_task_definition.task-definition-test.arn
  desired_count   = 1
#   ordered_placement_strategy {
#     type  = "binpack"
#     field = "cpu"
#   }
  load_balancer {
    target_group_arn = aws_lb_target_group.tcw_tg.arn
    container_name   = "pink-slon"
    container_port   = 3000
  }
  # Optional: Allow external changes without Terraform plan difference(for example ASG)
   lifecycle {
     ignore_changes = [desired_count]
   }
  launch_type = "EC2"
  depends_on  = [aws_lb_listener.alb_forward_listener,aws_iam_role_policy_attachment.ecs_task_execution_role]
  #depends_on  = [aws_lb_listener.alb_forward_listener]
  # capacity_provider_strategy {
  #   capacity_provider = aws_ecs_capacity_provider.test.name
  #   weight= 50
  # }
}
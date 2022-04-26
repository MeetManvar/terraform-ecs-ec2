
# data "aws_iam_policy_document" "ecs_task_execution_role" {
#   version = "2012-10-17"
#   statement {
#     sid     = ""
#     effect  = "Allow"
#     actions = ["sts:AssumeRole"]

#     principals {
#       type        = "Service"
#       identifiers = ["ecs-tasks.amazonaws.com"]
#     }
#   }
# }
# data "aws_iam_policy_document" "ecs_agent" {
#   statement {
#     actions = ["sts:AssumeRole"]
#       effect  = "Allow"
#     principals {
#       type        = "Service"
#       identifiers = ["ec2.amazonaws.com"]
#     }
#   }
# }

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecsrole1"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}
resource "aws_iam_role" "ecs_agent" {
  name               = "ecs-agent"
  assume_role_policy = data.aws_iam_policy_document.ecs_agent.json
  #  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
  
}


resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role       = aws_iam_role.ecs_agent.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}
resource "aws_iam_instance_profile" "ecs_agent" {
  name = "ecs-agent"
  role = aws_iam_role.ecs_agent.name
}
# resource "aws_iam_role" "ecs_task_execution_role" {
#   name               = "ecsrole1"
#   assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
# }



# resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
#   role       = aws_iam_role.ecs_task_execution_role.name
#   policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AmazonECSServiceRolePolicy"
# }
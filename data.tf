# data "aws_ecs_container_definition" "ecs-mongo" {
#   task_definition = "${data.aws_ecs_task_definition.mongo.id}"
#   container_name  = "pink-slon"
# }
# data "aws_ecs_task_definition" "mongo" {
#   task_definition = "${aws_ecs_task_definition.task-definition-test.family}"
# }

data "aws_iam_policy_document" "ecs_task_execution_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
data "aws_iam_policy_document" "ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]
      effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
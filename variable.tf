# output "name" {
#   value       = data.aws_ecs_container_definition.ecs-mongo
# }
variable "cluster_name" {
  type        = string
  description = "The name of AWS ECS cluster"
}

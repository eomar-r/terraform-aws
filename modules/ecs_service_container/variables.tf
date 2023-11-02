variable "app_name" {
  description = "The application name"
}
variable "cluster_id" {
  description = "The cluster id"
}
variable "task_definition_family" {
  description = "ARN for task definition"
}
variable "disered_count" {}
variable "security_groups_ids" {
  type        = list(any)
  description = "The SGs to use"
}
variable "public_subnets_ids" {
  type        = list(any)
  description = "The public subnets to use"
}
variable "aws_alb_target_group_arn" {}
variable "container_name" {}
variable "container_port" {}
variable "vpc_id" {}
variable "tags" {}
variable "enable_execute_command" {}
variable "assign_public_ip" {}
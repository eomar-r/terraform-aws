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
variable "private_subnets_ids" {
  type        = list(any)
  description = "The private subnets to use"
}
variable "aws_alb_target_group_arn" {}
variable "container_name" {}
variable "container_port" {}
variable "vpc_id" {}
variable "tags" {}
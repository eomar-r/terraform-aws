output "vpc_id" {
  value = data.aws_vpc.default.id
}

output "public_subnets" {
  value = data.aws_subnets.default.ids
}

output "alb_arn" {
  value = aws_lb.alb.arn
}

output "sg_alb_id" {
  value = aws_security_group.alb.id
}

output "ecs_cluster_id" {
  value = module.ecs.cluster_id
}
output "sg_ecs_cluster_id" {
  value = aws_security_group.containers.id
}
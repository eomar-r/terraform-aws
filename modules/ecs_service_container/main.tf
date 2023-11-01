data "aws_ecs_task_definition" "default" {
  task_definition = var.task_definition_family
}
resource "aws_ecs_service" "service" {
  name            = var.app_name
  cluster         = var.cluster_id
  task_definition = "${data.aws_ecs_task_definition.default.family}:${data.aws_ecs_task_definition.default.revision}"
  desired_count   = var.disered_count
  launch_type     = "FARGATE"
  #   enable_execute_command = terraform.workspace == "dev" ? true : false

  network_configuration {
    security_groups  = var.security_groups_ids
    subnets          = var.private_subnets_ids
    assign_public_ip = false # Ya que se deployan en una subred privada
  }

  load_balancer {
    target_group_arn = var.aws_alb_target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_alb_target_group" "default" {
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  lifecycle {
    create_before_destroy = true
  }
}
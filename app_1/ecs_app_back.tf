module "ecs_service_backend" {
  source     = "../modules/ecs_service_container"
  depends_on = [aws_ecs_task_definition.app_backend, aws_lb_target_group.app_backend]

  app_name                 = local.app_name
  cluster_id               = local.ecs_cluster_id
  task_definition_family   = aws_ecs_task_definition.app_backend.family
  disered_count            = 1
  security_groups_ids      = [local.sg_ecs_cluster_id]
  public_subnets_ids       = local.public_subnets
  aws_alb_target_group_arn = aws_lb_target_group.app_backend.arn
  container_name           = local.app_name
  container_port           = var.port_back
  vpc_id                   = local.vpc_id
  enable_execute_command   = false
  assign_public_ip         = true
  tags                     = local.tags
}

resource "aws_ecs_task_definition" "app_backend" {
  depends_on = [aws_iam_role.ecs_task_back]

  family                   = "${local.app_name}-family"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu_back
  memory                   = var.memory_back
  container_definitions = jsonencode([
    {
      name      = local.app_name
      image     = var.image_back
      cpu       = var.cpu_back
      memory    = var.memory_back
      essential = true
      portMappings = [
        {
          containerPort = var.port_back
          hostPort      = var.port_back
        }
      ]
    }
  ])
  runtime_platform {
    operating_system_family = "LINUX"
  }
  execution_role_arn = var.execution_role_arn
  task_role_arn      = aws_iam_role.ecs_task_back.arn

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_lb_target_group" "app_backend" {
  name        = "ecs-${local.app_name}"
  port        = var.port_back
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = local.vpc_id
  health_check {
    protocol            = "HTTP"
    path                = "/"
    healthy_threshold   = 5
    unhealthy_threshold = 3
    timeout             = 30
    interval            = 60
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

# Security group rule
resource "aws_security_group_rule" "sg_rule" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = local.sg_alb_id
  description       = "Ingress rule for app"
}

# Only for Backend applications: each app has its own listener at certain port
resource "aws_lb_listener" "app_backend" {
  depends_on        = [aws_lb_target_group.app_backend]
  load_balancer_arn = local.alb_arn
  port              = var.port_back
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_backend.arn
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_iam_role" "ecs_task_back" {
  name = "ecs-${local.app_name}"
  assume_role_policy = jsonencode(
    {
      "Version" : "2008-10-17",
      "Statement" : [
        {
          "Sid" : "",
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "ecs-tasks.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
  })
}

resource "aws_iam_role_policy" "ecs_task_back" {
  depends_on = [aws_iam_role.ecs_task_back]
  name       = "ecs-${local.app_name}"
  policy     = data.template_file.policy_task_back.rendered
  role       = aws_iam_role.ecs_task_back.id
}

data "template_file" "policy_task_back" {
  template = file("policies/politica_task_role.json")

  vars = {
    bucket_name = var.bucket_name
  }
}
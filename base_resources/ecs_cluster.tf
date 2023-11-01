locals {
  tags_ecs_cluster = {
    Servicio    = "contenedores"
    Responsable = "usuarioX"
    Name        = "${local.env}-${local.app_name}-containers"
  }
}

# https://registry.terraform.io/modules/terraform-aws-modules/ecs/aws/latest
module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name = "${local.env}-fargate"

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/${local.env}-fargate"
      }
    }
  }

  tags = local.tags_ecs_cluster
}

resource "aws_security_group" "containers" {
  name        = "${local.env}-containers"
  description = "Security group atachado a los contenedores."
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Permite todo desde el alb."
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags_ecs_cluster
}
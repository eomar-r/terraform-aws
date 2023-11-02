locals {
  tags_alb = {
    Servicio    = "redes"
    Responsable = "usuarioX"
    Name        = "${local.env}-${local.app_name}-alb"
  }
}

#DOCS: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
resource "aws_lb" "alb" {
  name               = "${local.env}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = data.aws_subnets.default.ids

  enable_deletion_protection = false
  drop_invalid_header_fields = true
  preserve_host_header       = true

  tags = local.tags_alb
}

/* security group for ALB */
resource "aws_security_group" "alb" {
  name        = "${local.env}-alb"
  description = "Security group atachado al application load balancer."
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow all ingress for HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags_alb
}

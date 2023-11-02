# Backend configuration
terraform {
  backend "s3" {
    region               = "us-east-2"
    bucket               = "terraform-eomar"
    key                  = "app_1.tfstate"
    encrypt              = true #AES-256 encryption    
    workspace_key_prefix = "tf-env"
  }
}

############
## Aqui se cargan los remote states de otros servicios y se establecen como variables locales.
data "terraform_remote_state" "base_resources" {
  backend = "s3"
  config = {
    region = "us-east-2"
    bucket = "terraform-eomar"
    key    = "tf-env/${local.env}/base_resources.tfstate"
  }
}

locals {
  vpc_id            = data.terraform_remote_state.base_resources.outputs.vpc_id
  public_subnets    = data.terraform_remote_state.base_resources.outputs.public_subnets
  alb_arn           = data.terraform_remote_state.base_resources.outputs.alb_arn
  sg_alb_id         = data.terraform_remote_state.base_resources.outputs.sg_alb_id
  ecs_cluster_id    = data.terraform_remote_state.base_resources.outputs.ecs_cluster_id
  sg_ecs_cluster_id = data.terraform_remote_state.base_resources.outputs.sg_ecs_cluster_id
}
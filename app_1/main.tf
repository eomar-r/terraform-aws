terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">=1.2.0"
}

provider "aws" {
  region = local.region
  default_tags {
    tags = {
      env         = local.env
      Responsable = "usuario1"
      Costo       = local.app_name
    }
  }
}

locals {
  region   = "us-east-2"
  env      = terraform.workspace
  app_name = "app-1"

  only_in_dev_map = {
    dev  = 1
    qa   = 0
    prod = 0
  }
  only_in_dev = local.only_in_dev_map[terraform.workspace]

  tags = {
    Name = "app-1"
  }
}
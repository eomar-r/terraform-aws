terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      env         = terraform.workspace
      Responsable = "usuario1"
      Costo       = "recursos compartidos"
    }
  }
}

locals {
  app_name = "base"
  env      = terraform.workspace
  region   = "us-west-2"

  only_in_dev_map = {
    dev  = 1
    qa   = 0
    prod = 0
  }
}
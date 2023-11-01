terraform {
  backend "s3" {
    region               = "us-east-2"
    bucket               = "terraform-eomar"
    key                  = "base_resources.tfstate"
    encrypt              = true
    workspace_key_prefix = "tf-env"
  }
}
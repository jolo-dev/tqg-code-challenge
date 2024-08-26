terraform {
    backend "s3" {
        bucket = "tqg-terraform-state-bucket"
        key    = "terraform.tfstate"
        region = "eu-central-1"
      
    }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  shared_credentials_files = ["$HOME/.aws/credentials"]
  region = "eu-central-1"
}
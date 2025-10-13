
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket  = "ci-jenkins-s3-bucket-state-322"
    key     = "terraform/state/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}



terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.8.0"
    }
  }
}
provider "aws" {
  region  = var.region
  profile = var.accountname
}

terraform {
  backend "s3" {
    profile        = "yourprofile"
    bucket         = "yourtfstate"
    key            = "key.tfstate"
    region         = "yourregion"
    encrypt        = true
    dynamodb_table = "yourdynamodbtable"
  }
}
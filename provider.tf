
provider "aws" {
  region  = var.region
  profile = var.accountname
}

terraform {
  backend "s3" {
    profile        = ""
    bucket         = "changeme"
    key            = "changeme"
    region         = "changeme"
    encrypt        = true
    dynamodb_table = "changeme"
  }
}
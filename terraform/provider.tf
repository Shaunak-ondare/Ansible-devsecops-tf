terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "YOUR_BUCKET_NAME" # Change this
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "YOUR_DYNAMODB_TABLE_NAME" # Change this
    encrypt        = true
  }
}

provider "aws" {
  region = "ap-south-1"
}

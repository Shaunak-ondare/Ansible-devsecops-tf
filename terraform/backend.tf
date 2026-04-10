terraform {
  backend "s3" {
    bucket       = "aws-tf-backend-shaunak-221"
    key          = "terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
    encrypt      = true
  }
}

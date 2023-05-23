# This file is used to store the terraform state file in S3 bucket
# Locals are not allowed in backend config
terraform {
  backend "s3" {
    bucket         = "devopslearning-terraform-backend"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "devopslearning-terraform-locks"
    encrypt        = true
  }
}

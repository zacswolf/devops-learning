locals {
  aws_region = "us-east-1"
  bucket_name = "devopslearning-terraform-backend"
  dynamodb_table  = "devopslearning-terraform-locks"
}

provider "aws" {
  region = local.aws_region
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = local.bucket_name
}
resource "aws_s3_bucket_ownership_controls" "my_bucket_ownership_controls" {
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_versioning" "my_bucket_versioning" {
  bucket = aws_s3_bucket.my_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name           = local.dynamodb_table
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

terraform {
  backend "s3" {
    bucket         = "STATE_BUCKET_NAME"
    key            = "terraform-assessment/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "LOCK_TABLE_NAME"
    encrypt        = true
  }
}

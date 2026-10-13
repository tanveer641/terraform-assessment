variable "aws_region" {
  description = "AWS region for IAM-related resources."
  type        = string
  default     = "ap-south-1"
}

variable "account_a_id" {
  description = "AWS Account A ID."
  type        = string
  default     = "000000000000"
}

variable "account_b_id" {
  description = "AWS Account B ID."
  type        = string
  default     = "111111111111"
}

variable "s3_bucket_name" {
  description = "The specific S3 bucket accessible by roleC."
  type        = string
  default     = "assessment-bucket"
}

variable "console_pgp_key" {
  description = "Base64-encoded PGP public key used to encrypt initial console passwords."
  type        = string
}

variable "account_b_profile" {
  description = "AWS CLI profile authorized to manage Account B."
  type        = string
  default     = "account-b-admin"
}

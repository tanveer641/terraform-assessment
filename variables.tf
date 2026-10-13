
variable "aws_region" {
  description = "AWS region for the assessment."
  type        = string
  default     = "ap-south-1"
}

variable "ami_id" {
  description = "Valid AMI ID for the selected region."
  type        = string
}

variable "subnet_id" {
  description = "Existing subnet ID for EC2 placement."
  type        = string
}

variable "instances" {
  description = "Configuration for all five EC2 instances."
  type = map(object({
    instance_type = string
    key_name      = string
    root_volume = object({
      type = string
      size = number
      iops = optional(number)
    })
    environment = string
    owner       = string
  }))

  validation {
    condition     = length(var.instances) == 5
    error_message = "Configure exactly five instances."
  }
}

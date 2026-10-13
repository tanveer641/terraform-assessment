variable "instances" {
  description = "EC2 instances to provision."
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
    error_message = "Exactly five EC2 instances must be configured."
  }

  validation {
    condition = alltrue([
      for instance in values(var.instances) :
      contains(["gp3", "io1", "io2", "gp2", "standard", "st1", "sc1"], instance.root_volume.type)
    ])
    error_message = "Use a supported EBS root volume type."
  }
}

variable "ami_id" {
  description = "AMI ID available in the selected AWS region."
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the EC2 instances will be deployed."
  type        = string
}

variable "protected_instance_name" {
  description = "Map key of the instance protected from Terraform destruction."
  type        = string
  default     = "critical"
}

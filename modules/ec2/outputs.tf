
output "instance_ids" {
  description = "Map of instance names to EC2 instance IDs."

  value = merge(
    { for name, instance in aws_instance.instances : name => instance.id },
    { for instance in aws_instance.protected : var.protected_instance_name => instance.id }
  )
}

output "private_ips" {
  description = "Map of instance names to private IP addresses."

  value = merge(
    { for name, instance in aws_instance.instances : name => instance.private_ip },
    { for instance in aws_instance.protected : var.protected_instance_name => instance.private_ip }
  )
}

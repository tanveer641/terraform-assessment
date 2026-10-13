output "instance_ids" {
  description = "EC2 instance name to instance ID."
  value       = module.ec2.instance_ids
}

output "private_ips" {
  description = "EC2 instance name to private IP."
  value       = module.ec2.private_ips
}

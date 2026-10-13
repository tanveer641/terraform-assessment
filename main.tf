module "ec2" {
  source = "./modules/ec2"

  ami_id                  = var.ami_id
  subnet_id               = var.subnet_id
  instances               = var.instances
  protected_instance_name = "critical"
}

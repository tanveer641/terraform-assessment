
resource "aws_instance" "instances" {
  for_each = {
    for name, config in var.instances :
    name => config
    if name != var.protected_instance_name
  }

  ami           = var.ami_id
  instance_type = each.value.instance_type
  key_name      = each.value.key_name
  subnet_id     = var.subnet_id

  root_block_device {
    volume_type = each.value.root_volume.type
    volume_size = each.value.root_volume.size
    iops        = each.value.root_volume.iops
  }

  tags = {
    Name        = each.key
    Environment = each.value.environment
    Owner       = each.value.owner
  }
}

resource "aws_instance" "protected" {
  count = contains(keys(var.instances), var.protected_instance_name) ? 1 : 0

  ami           = var.ami_id
  instance_type = var.instances[var.protected_instance_name].instance_type
  key_name      = var.instances[var.protected_instance_name].key_name
  subnet_id     = var.subnet_id

  root_block_device {
    volume_type = var.instances[var.protected_instance_name].root_volume.type
    volume_size = var.instances[var.protected_instance_name].root_volume.size
    iops        = var.instances[var.protected_instance_name].root_volume.iops
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = var.protected_instance_name
    Environment = var.instances[var.protected_instance_name].environment
    Owner       = var.instances[var.protected_instance_name].owner
  }
}

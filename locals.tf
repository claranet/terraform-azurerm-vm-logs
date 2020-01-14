locals {
  default_tags = {
    env   = var.environment
    stack = var.stack
  }

  vm_names = [for v in var.vm_ids : element(split("/", v), 8)]

  vms = zipmap(local.vm_names, var.vm_ids)
}

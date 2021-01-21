locals {
  default_tags = {
    env   = var.environment
    stack = var.stack
  }

  settings_linux = {
    commandToExecute = "/bin/bash -c \"[[ $(awk -F'=' '/^ID/ { print $2 }' /etc/os-release 2>/dev/null) =~ 'debian' ]] && apt update && apt install -y gpg || true\""
  }

  diag_name = lower(format("%s-%s", element(split("/", var.vm_id), 8), var.vm_extension_name_suffix))
}

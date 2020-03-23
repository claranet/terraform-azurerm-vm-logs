locals {
  default_tags = {
    env   = var.environment
    stack = var.stack
  }

  settings_linux = {
    commandToExecute = "[[ $(awk -F'=' '/ID_LIKE/ { print $2 }' /etc/os-release 2>/dev/null) == 'debian' ]] && apt update && apt install -y gpg || true"
  }
}

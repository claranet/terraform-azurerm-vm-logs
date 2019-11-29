data "template_file" "diag_json_config" {
  template = file("${path.module}/diag_config_3.0.json")
  count    = var.vm_count
  vars = {
    vm_id            = element(var.vm_ids, count.index)
    storage_account  = var.diagnostics_storage_account_name
    log_level_config = var.syslog_log_level_config
  }
}

locals {
  default_tags = {
    env   = var.environment
    stack = var.stack
  }
}

resource "azurerm_virtual_machine_extension" "diagnostics" {
  name = coalesce(
    var.vm_extension_custom_name,
    "${element(split("/", element(var.vm_ids, count.index)), 8)}-${count.index}-linux-diagnostics",
  )
  count                = var.vm_count
  location             = var.location
  resource_group_name  = element(split("/", element(var.vm_ids, count.index)), 4)
  virtual_machine_name = element(split("/", element(var.vm_ids, count.index)), 8)
  publisher            = "Microsoft.Azure.Diagnostics"
  type                 = "LinuxDiagnostic"
  type_handler_version = var.diagnostics_linux_extension_version

  auto_upgrade_minor_version = true

  settings = data.template_file.diag_json_config[count.index].rendered

  protected_settings = <<SETTINGS
    {
        "storageAccountName": "${var.diagnostics_storage_account_name}",
        "storageAccountSasToken": "${var.diagnostics_storage_account_sas_token}"
    }
SETTINGS

  tags = merge(local.default_tags, var.tags)
}

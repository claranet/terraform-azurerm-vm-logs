data "template_file" "diag_json_config" {
  for_each = local.vms

  template = file("${path.module}/diag_config_3.0.json")

  vars = {
    vm_id            = each.value
    storage_account  = var.diagnostics_storage_account_name
    log_level_config = var.syslog_log_level_config
  }
}

resource "azurerm_virtual_machine_extension" "diagnostics" {
  for_each = local.vms

  name = format("%s-%s", each.key, var.vm_extension_name_suffix)

  location             = var.location
  resource_group_name  = element(split("/", each.value), 4)
  virtual_machine_name = each.key
  publisher            = "Microsoft.Azure.Diagnostics"
  type                 = "LinuxDiagnostic"
  type_handler_version = var.diagnostics_linux_extension_version

  auto_upgrade_minor_version = true

  settings = data.template_file.diag_json_config[each.key].rendered

  protected_settings = <<SETTINGS
    {
        "storageAccountName": "${var.diagnostics_storage_account_name}",
        "storageAccountSasToken": "${var.diagnostics_storage_account_sas_token}"
    }
SETTINGS

  tags = merge(local.default_tags, var.tags)
}

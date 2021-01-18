data "template_file" "diag_json_config" {
  template = file("${path.module}/diag_config_3.0.json")

  vars = {
    vm_id            = var.vm_id
    storage_account  = var.diagnostics_storage_account_name
    log_level_config = var.syslog_log_level_config
  }
}

resource "azurerm_virtual_machine_extension" "diagnostics" {
  name = coalesce(
    var.vm_extension_custom_name,
    local.diag_name,
  )

  location             = var.location
  resource_group_name  = var.resource_group_name
  virtual_machine_id   = var.vm_id
  publisher            = "Microsoft.Azure.Diagnostics"
  type                 = "LinuxDiagnostic"
  type_handler_version = var.diagnostics_linux_extension_version

  auto_upgrade_minor_version = true

  settings = data.template_file.diag_json_config.rendered

  protected_settings = <<SETTINGS
    {
        "storageAccountName": "${var.diagnostics_storage_account_name}",
        "storageAccountSasToken": "${var.diagnostics_storage_account_sas_token}"
    }
SETTINGS


  tags = merge(local.default_tags, var.tags)

  depends_on = [azurerm_virtual_machine_extension.requirements]
}

resource "azurerm_virtual_machine_extension" "requirements" {
  count = var.vm_count

  name                       = "${element(split("/", element(var.vm_ids, count.index)), 8)}-run-command"
  virtual_machine_id         = element(var.vm_ids, count.index)
  publisher                  = "Microsoft.CPlat.Core"
  type                       = "RunCommandLinux"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
  protected_settings         = jsonencode(local.settings_linux)
  tags                       = merge(local.default_tags, var.tags)
}


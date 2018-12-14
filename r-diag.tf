data "template_file" "diag_xml_config" {
  template = "${file("${path.module}/diag_config.xml")}"

  vars {
    vm_id = "${var.vm_id}"
  }
}

resource "azurerm_virtual_machine_extension" "diagnostics" {
  name                 = "vm-${var.vm_id}-linux-diagnostics"
  location             = "${var.azure_region}"
  resource_group_name  = "${var.resource_group_name}"
  virtual_machine_name = "${var.vm_name}"
  publisher            = "Microsoft.OSTCExtensions"
  type                 = "LinuxDiagnostic"
  type_handler_version = "2.3"

  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
        "xmlCfg": "${base64encode(data.template_file.diag_xml_config.rendered)}",
        "StorageAccount": "${var.diagnotics_storage_account}"
    }
SETTINGS

  protected_settings = <<SETTINGS
    {
        "storageAccountName": "${var.diagnotics_storage_account}",
        "storageAccountKey": "${var.diagnotics_storage_key}"
    }
SETTINGS

  tags = "${var.tags}"
}

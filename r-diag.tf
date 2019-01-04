data "template_file" "diag_xml_config" {
  template = "${file("${path.module}/diag_config.xml")}"

  vars {
    vm_id = "${var.vm_id}"
  }
}

locals {
  default_tags = {
    env = "${var.environment}"
    stack = "${var.stack}"
  }
}


resource "azurerm_virtual_machine_extension" "diagnostics" {
  name                 = "vm-${var.vm_id}-linux-diagnostics"
  location             = "${var.location}"
  resource_group_name  = "${var.resource_group_name}"
  virtual_machine_name = "${var.vm_name}"
  publisher            = "Microsoft.OSTCExtensions"
  type                 = "LinuxDiagnostic"
  type_handler_version = "${var.diagnostics_linux_extension_version}"

  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
        "xmlCfg": "${base64encode(data.template_file.diag_xml_config.rendered)}",
        "StorageAccount": "${var.diagnotics_storage_account_name}"
    }
SETTINGS

  protected_settings = <<SETTINGS
    {
        "storageAccountName": "${var.diagnotics_storage_account_name}",
        "storageAccountKey": "${var.diagnotics_storage_account_key}"
    }
SETTINGS

  tags = "${merge(local.default_tags, var.tags)}"
}

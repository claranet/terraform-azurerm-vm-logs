# Azure VM Linux - Enable diagnostics logs
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/vm-logs/azurerm/)

This feature enables Diagnostics VM extension for Linux VM.
It allows you to push logs on an Azure Storage Account and to enable Logs Analytics dashboards.

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 5.x.x       | 0.15.x & 1.0.x    | >= 2.0          |
| >= 4.x.x       | 0.13.x            | >= 2.0          |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

```hcl
module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure_region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "logs" {
  source  = "claranet/run-common/azurerm//modules/logs"
  version = "x.x.x"

  client_name    = var.client_name
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name
}


module "azure_network_vnet" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  environment    = var.environment
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name
  vnet_cidr           = ["10.10.0.0/16"]
}

module "azure_network_subnet" {
  source  = "claranet/subnet/azurerm"
  version = "x.x.x"

  environment    = var.environment
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  virtual_network_name = module.azure_network_vnet.virtual_network_name
  subnet_cidr_list     = ["10.10.10.0/24"]
}

module "az_monitor" {
  source  = "claranet/run-iaas/azurerm//modules/vm-monitoring"
  version = "x.x.x"

  client_name    = var.client_name
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name        = module.rg.resource_group_name
  log_analytics_workspace_id = module.logs.log_analytics_workspace_id

  extra_tags = {
    foo = "bar"
  }
}

resource "azurerm_availability_set" "vm_avset" {
  name                = "${var.stack}-${var.client_name}-${module.azure_region.location_short}-${var.environment}-as"
  location            = module.azure_region.location
  resource_group_name = module.rg.resource_group_name
  managed             = true
}

module "vm" {
  source  = "claranet/linux-vm/azurerm"
  version = "x.x.x"

  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.resource_group_name


  subnet_id      = module.azure_network_subnet.subnet_id
  vm_size        = "Standard_B2s"
  custom_name    = "app-${var.stack}-${var.client_name}-${module.azure_region.location_short}-${var.environment}-vm"
  admin_username = var.vm_administrator_login
  ssh_public_key = var.ssh_public_key

  diagnostics_storage_account_name      = module.logs.logs_storage_account_name
  diagnostics_storage_account_sas_token = null # used by legacy agent only
  azure_monitor_data_collection_rule_id = module.az_monitor.data_collection_rule_id
  log_analytics_workspace_guid          = module.logs.log_analytics_workspace_guid
  log_analytics_workspace_key           = module.logs.log_analytics_workspace_primary_key

  availability_set_id = azurerm_availability_set.vm_avset.id
  # or use Availability Zone
  # zone_id = 1

  vm_image = {
    publisher = "Debian"
    offer     = "debian-10"
    sku       = "10"
    version   = "latest"
  }

  storage_data_disk_config = {
    appli_data_disk = {
      name                 = "appli_data_disk"
      disk_size_gb         = 512
      lun                  = 0
      storage_account_type = "Standard_LRS"
      extra_tags = {
        some_data_disk_tag = "some_data_disk_tag_value"
      }
    }
    logs_disk = {
      # Used to define Logical Unit Number (LUN) parameter
      lun          = 10
      disk_size_gb = 64
      caching      = "ReadWrite"
      extra_tags = {
        some_data_disk_tag = "some_data_disk_tag_value"
      }
    }
  }
}

module "vm_logs" {
  source  = "claranet/vm-logs/azurerm"
  version = "x.x.x"

  environment = var.environment
  stack       = var.stack

  vm_id = module.vm.vm_id

  diagnostics_storage_account_name      = module.logs.logs_storage_account_name
  diagnostics_storage_account_sas_token = module.logs.logs_storage_account_sas_token

  tags = {
    environment = var.environment
    stack       = var.stack
  }
}

```

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.0 |
| template | >= 2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_virtual_machine_extension.diagnostics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.requirements](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [template_file.diag_json_config](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| default\_tags\_enabled | Option to enable or disable default tags | `bool` | `true` | no |
| diagnostics\_linux\_extension\_version | Linux VM diagnostics extension version | `string` | `"3.0"` | no |
| diagnostics\_storage\_account\_name | Azure Storage Account to use for logs and diagnostics | `string` | n/a | yes |
| diagnostics\_storage\_account\_sas\_token | Azure Storage Account SAS Token. An Account SAS token for Blob and Table services (ss='bt'), applicable to containers and objects (srt='co'), which grants add, create, list, update, and write permissions (sp='acluw'). Do not include the leading question-mark (?). | `string` | n/a | yes |
| environment | Project environment | `string` | n/a | yes |
| stack | Project stack name | `string` | n/a | yes |
| syslog\_log\_level\_config | Syslog Event Configuration log level [Can be LOG\_DEBUG, LOG\_INFO, LOG\_NOTICE, LOG\_ERR, LOG\_CRIT, LOG\_ALERT, LOG\_EMERG] | `string` | `"LOG_ERR"` | no |
| tags | Tags to assign on ressources | `map(string)` | `{}` | no |
| vm\_extension\_custom\_name | Custom VM extension name. | `string` | `null` | no |
| vm\_extension\_name\_suffix | Extension suffix name. | `string` | `"linux-diagnostics"` | no |
| vm\_id | Azure Linux VM ID to enable Diagnostics | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
## Related documentation

Microsoft Azure documentation: [Use Linux Diagnostic Extension to monitor metrics and logs](https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/diagnostics-linux).

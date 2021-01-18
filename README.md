# Azure VM Linux - Enable diagnostics logs
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/vm-logs/azurerm/)

This feature enables Diagnostics VM extension for Linux VM.
It allows you to push logs on an Azure Storage Account and to enable Logs Analytics dashboards.

## Version compatibility

| Module version | Terraform version | AzureRM version |
|----------------|-------------------| --------------- |
| >= 4.x.x       | 0.13.x            | >= 2.0          |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

```hcl
module "azure-region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure-region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "run-common" {
  source = "..."

  [..]
}

module "vm-logs" {
  source  = "claranet/vm-logs/azurerm"
  version = "x.x.x"

  for_each = toset([for vm in module.linux-vms : vm.vm_id])

  location       = module.azure-region.location
  location_short = module.azure-region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  diagnostics_storage_account_name      = module.run-common.logs_storage_account_name
  diagnostics_storage_account_sas_token = module.run-common.logs_storage_account_sas_token["sastoken"]

  vm_id = each.value

  tags = {
    environment = var.environment
    stack       = var.stack
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| client\_name | Client name/account used in naming | `string` | n/a | yes |
| diagnostics\_linux\_extension\_version | Linux VM diagnostics extension version | `string` | `"3.0"` | no |
| diagnostics\_storage\_account\_name | Azure Storage Account to use for logs and diagnostics | `string` | n/a | yes |
| diagnostics\_storage\_account\_sas\_token | Azure Storage Account SAS Token. An Account SAS token for Blob and Table services (ss='bt'), applicable to containers and objects (srt='co'), which grants add, create, list, update, and write permissions (sp='acluw'). Do not include the leading question-mark (?). | `string` | n/a | yes |
| environment | Project environment | `string` | n/a | yes |
| location | Specifies the supported Azure location where the resource exists. | `string` | n/a | yes |
| location\_short | Short version of the Azure location, used by naming convention. | `string` | n/a | yes |
| resource\_group\_name | The name of the resource group in which the VM has been created. | `string` | n/a | yes |
| stack | Project stack name | `string` | n/a | yes |
| syslog\_log\_level\_config | Syslog Event Configuration log level [Can be LOG\_DEBUG, LOG\_INFO, LOG\_NOTICE, LOG\_ERR, LOG\_CRIT, LOG\_ALERT, LOG\_EMERG] | `string` | `"LOG_ERR"` | no |
| tags | Tags to assign on ressources | `map(string)` | `{}` | no |
| vm\_extension\_custom\_name | Custom VM extension name. | `string` | `null` | no |
| vm\_extension\_name\_suffix | Extension suffix name. | `string` | `"linux-diagnostics"` | no |
| vm\_id | Azure Linux VM ID to enable Diagnostics | `string` | n/a | yes |

## Related documentation

Microsoft Azure documentation: [Use Linux Diagnostic Extension to monitor metrics and logs](https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/diagnostics-linux).

Terraform resource documentation: [terraform.io/docs/providers/azurerm/r/virtual_machine_extension.html](https://www.terraform.io/docs/providers/azurerm/r/virtual_machine_extension.html).

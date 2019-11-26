# Azure VM Linux - Enable diagnostics logs
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/vm-logs/azurerm/)

This feature enables Diagnostics VM extension for Linux VM.
It allows you to push logs on an Azure Storage Account and to enable Logs Analytics dashboards.

## Requirements

* [AzureRM Terraform provider](https://www.terraform.io/docs/providers/azurerm/) >= 1.32

## Terraform version compatibility

| Module version | Terraform version |
|----------------|-------------------|
| >= 2.x.x       | 0.12.x            |
| < 2.x.x        | 0.11.x            |

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

module "log-analytics" {
  source = "..."

  [..]
}

module "vm-001" {
  source = "..."

  [..]
}

module "vm-001-logs" {
  source  = "claranet/vm-logs/azurerm"
  version = "x.x.x"

  location       = module.azure-region.location
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack


  diagnostics_storage_account_name      = module.log-analytics.storage_account_name
  diagnostics_storage_account_sas_token = module.log-analytics.storage_account_sas_token

  vm_ids   = ["module.vm-001.vm_id"]

  tags = {
    environment = var.environment
    stack       = var.stack
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| client\_name | Client name/account used in naming | string | n/a | yes |
| diagnostics\_linux\_extension\_version | Linux VM diagnostics extension version | string | `"3.0"` | no |
| diagnostics\_storage\_account\_name | Azure Storage Account to use for logs and diagnostics | string | n/a | yes |
| diagnostics\_storage\_account\_sas\_token | Azure Storage Account SAS Token. An Account SAS token for Blob and Table services (ss='bt'), applicable to containers and objects (srt='co'), which grants add, create, list, update, and write permissions (sp='acluw'). Do not include the leading question-mark (?). | string | n/a | yes |
| environment | Project environment | string | n/a | yes |
| location | Specifies the supported Azure location where the resource exists. | string | n/a | yes |
| stack | Project stack name | string | n/a | yes |
| syslog\_log\_level\_config | Syslog Event Configuration log level [Can be LOG_DEBUG, LOG_INFO, LOG_NOTICE, LOG_ERR, LOG_CRIT, LOG_ALERT, LOG_EMERG] | string | `"LOG_ERR"` | no |
| tags | Tags to assign on ressources | map | `<map>` | no |
| vm\_extension\_custom\_name | Extension name, auto-generated if empty. | string | `""` | no |
| vm\_ids | List of Azure Linux VM ID to enable Diagnostics | string | n/a | yes |

## Related documentation

Microsoft Azure documentation: [Use Linux Diagnostic Extension to monitor metrics and logs](https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/diagnostics-linux).

Terraform resource documentation: [terraform.io/docs/providers/azurerm/r/virtual_machine_extension.html](https://www.terraform.io/docs/providers/azurerm/r/virtual_machine_extension.html).

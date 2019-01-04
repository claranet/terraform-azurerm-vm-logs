# Azure VM Linux - Enable diagnostics logs

This feature enables Diagnostics VM extension for Linux VM.
It allows you to push logs on an Azure Storage Account and to enable Logs Analytics dashboards.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| client_name | Client name/account used in naming | string | - | yes |
| diagnostics_linux_extension_version | Linux VM diagnostics extension version | string | `3.0` | no |
| diagnostics_storage_account_name | Azure Storage Account to use for logs and diagnostics | string | - | yes |
| diagnostics_storage_account_sas_token | Azure Storage Account SAS Token. An Account SAS token for Blob and Table services (ss='bt'), applicable to containers and objects (srt='co'), which grants add, create, list, update, and write permissions (sp='acluw'). Do not include the leading question-mark (?). | string | - | yes |
| environment | Project environment | string | - | yes |
| location | Specifies the supported Azure location where the resource exists. | string | - | yes |
| location_short | Short version of the Azure location, used by naming convention. | string | - | yes |
| resource_group_name | The name of the resource group in which the VM has been created. | string | - | yes |
| stack | Project stack name | string | - | yes |
| tags | Tags to assign on ressources | map | `<map>` | no |
| vm_extension_custom_name | Extension name, auto-generated if empty. | string | `` | no |
| vm_id | Azure Linux VM ID to enable Diagnostics | string | - | yes |
| vm_name | Azure Linux VM name to enable Diagnostics | string | - | yes |

## Related documentation

(Use Linux Diagnostic Extension to monitor metrics and logs)[https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/diagnostics-linux]

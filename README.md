# Azure VM Linux - Enable diagnostics logs

This features enables Diagnostics VM extension for Linux VM.
It let's you push logs on an Azure Storage and let you enable Logs Analytics dashboards.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| azure_region | Specifies the supported Azure location where the resource exists. | string | - | yes |
| azure_short_region | Short version of the Azure location, used by naming convention. | string | - | yes |
| client_name | Client name/account used in naming | string | - | yes |
| diagnostics_linux_extension_version | Linux VM diagnostics extension version | string | `2.3` | no |
| diagnotics_storage_account | Azure Storage Account to use for logs and diagnotics | string | - | yes |
| diagnotics_storage_key | Azure Storage Account access key | string | - | yes |
| environment | Project environment | string | - | yes |
| resource_group_name | The name of the resource group in which the VM has been created. | string | - | yes |
| stack | Project stack name | string | - | yes |
| tags | Tags to assign on ressources | map | `<map>` | no |
| vm_id | Azure Linux VM ID to enable Diagnostics | string | - | yes |
| vm_name | Azure Linux VM name to enable Diagnostics | string | - | yes |

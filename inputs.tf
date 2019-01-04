// ========= Global variables
variable "client_name" {
  description = "Client name/account used in naming"
}

variable "environment" {
  description = "Project environment"
}

variable "stack" {
  description = "Project stack name"
}

variable "resource_group_name" {
  description = "The name of the resource group in which the VM has been created."
}

variable "location" {
  description = "Specifies the supported Azure location where the resource exists."
}

variable "location_short" {
  description = "Short version of the Azure location, used by naming convention."
}

variable "tags" {
  description = "Tags to assign on ressources"
  type        = "map"
  default     = {}
}

// ========= VM variables
variable "vm_name" {
  description = "Azure Linux VM name to enable Diagnostics"
}

variable "vm_id" {
  description = "Azure Linux VM ID to enable Diagnostics"
}

// ========= Storage logs variables
variable "diagnotics_storage_account_name" {
  description = "Azure Storage Account to use for logs and diagnotics"
}

variable "diagnotics_storage_account_key" {
  description = "Azure Storage Account access key"
}

variable "diagnostics_linux_extension_version" {
  description = "Linux VM diagnostics extension version"
  default     = "2.3"
}

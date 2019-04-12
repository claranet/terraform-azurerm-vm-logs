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

variable "vm_extension_custom_name" {
  description = "Extension name, auto-generated if empty."
  default     = ""
}

// ========= VM variables
variable "vm_name" {
  description = "Azure Linux VM name to enable Diagnostics"
}

variable "vm_id" {
  description = "Azure Linux VM ID to enable Diagnostics"
}

// ========= Storage logs variables
variable "diagnostics_storage_account_name" {
  description = "Azure Storage Account to use for logs and diagnostics"
}

variable "diagnostics_storage_account_sas_token" {
  description = "Azure Storage Account SAS Token. An Account SAS token for Blob and Table services (ss='bt'), applicable to containers and objects (srt='co'), which grants add, create, list, update, and write permissions (sp='acluw'). Do not include the leading question-mark (?)."
}

variable "diagnostics_linux_extension_version" {
  description = "Linux VM diagnostics extension version"
  default     = "3.0"
}

variable "syslog_log_level_config" {
  description = "Syslog Event Configuration log level [Can be LOG_DEBUG, LOG_INFO, LOG_NOTICE, LOG_ERR, LOG_CRIT, LOG_ALERT, LOG_EMERG]"
  default     = "LOG_DEBUG"
}

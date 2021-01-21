// ========= Global variables
variable "client_name" {
  description = "Client name/account used in naming"
  type        = string
}

variable "environment" {
  description = "Project environment"
  type        = string
}

variable "stack" {
  description = "Project stack name"
  type        = string
}

variable "location" {
  description = "Specifies the supported Azure location where the resource exists."
  type        = string
}

variable "location_short" {
  description = "Short version of the Azure location, used by naming convention."
  type        = string
}

variable "tags" {
  description = "Tags to assign on ressources"
  type        = map(string)
  default     = {}
}

variable "vm_extension_name_suffix" {
  description = "Extension suffix name."
  type        = string
  default     = "linux-diagnostics"
}

variable "vm_extension_custom_name" {
  description = "Custom VM extension name."
  type        = string
  default     = null
}

// ========= VM variables

variable "vm_id" {
  description = "Azure Linux VM ID to enable Diagnostics"
  type        = string
}

// ========= Storage logs variables
variable "diagnostics_storage_account_name" {
  description = "Azure Storage Account to use for logs and diagnostics"
  type        = string
}

variable "diagnostics_storage_account_sas_token" {
  description = "Azure Storage Account SAS Token. An Account SAS token for Blob and Table services (ss='bt'), applicable to containers and objects (srt='co'), which grants add, create, list, update, and write permissions (sp='acluw'). Do not include the leading question-mark (?)."
  type        = string
}

variable "diagnostics_linux_extension_version" {
  description = "Linux VM diagnostics extension version"
  default     = "3.0"
  type        = string
}

variable "syslog_log_level_config" {
  description = "Syslog Event Configuration log level [Can be LOG_DEBUG, LOG_INFO, LOG_NOTICE, LOG_ERR, LOG_CRIT, LOG_ALERT, LOG_EMERG]"
  type        = string
  default     = "LOG_ERR"
}

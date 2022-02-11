variable "default_tags_enabled" {
  description = "Option to enable or disable default tags"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to assign on ressources"
  type        = map(string)
  default     = {}
}

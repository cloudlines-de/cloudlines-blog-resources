variable "name_suffix" {
  type        = string
  default     = ""
  description = "Suffix added to all names. Needed for automated testing."
}

variable "name" {
  type        = string
  description = "Used for naming all resources"
}

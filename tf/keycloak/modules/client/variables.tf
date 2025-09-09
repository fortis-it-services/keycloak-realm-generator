variable "realm_id" {
  type        = string
  description = "Realm ID"
}

variable "client_id" {
  type        = string
  description = "Client ID"
}

variable "client_name" {
  type        = string
  description = "Client Name"
  default     = ""
}

variable "client_description" {
  type        = string
  description = "Client Description"
  default     = ""
}

variable "client_valid_redirect_uris" {
  type        = set(string)
  description = "Valid Redirect URIs"
}

variable "group_role_mappings" {
  type        = map(set(string))
  description = "Group to Role Mappings"
  default     = {}
}

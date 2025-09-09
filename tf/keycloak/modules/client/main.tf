terraform {
  required_version = ">= 1.0.0"

  required_providers {
    keycloak = {
      source  = "keycloak/keycloak"
      version = ">= 5.4.0"
    }
  }
}

resource "keycloak_openid_client" "this" {
  realm_id              = var.realm_id
  client_id             = var.client_id
  name                  = var.client_name != "" ? var.client_name : var.client_id
  description           = var.client_description
  access_type           = "CONFIDENTIAL"
  standard_flow_enabled = true
  valid_redirect_uris   = var.client_valid_redirect_uris
}

locals {
  group_names = toset([for group_name, roles in var.group_role_mappings : group_name])
  roles       = toset(flatten([for group_name, roles in var.group_role_mappings : roles]))
}

resource "keycloak_role" "this" {
  for_each  = local.roles
  realm_id  = var.realm_id
  name      = each.value
  client_id = keycloak_openid_client.this.id
}

data "keycloak_group" "this" {
  for_each = local.group_names
  realm_id = var.realm_id
  name     = each.value
}

resource "keycloak_group_roles" "this" {
  for_each = var.group_role_mappings
  realm_id = var.realm_id
  group_id = data.keycloak_group.this[each.key].id
  role_ids = [for role_name in each.value : keycloak_role.this[role_name].id]
}

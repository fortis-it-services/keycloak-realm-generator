resource "keycloak_realm" "this" {
  realm = "awesome-realm"
  display_name = "Super Awesome Realm"
}

resource "keycloak_openid_client" "test" {
  realm_id                 = keycloak_realm.this.id
  client_id                = "awesome-client"
  name                     = "Awesome Client Name"
  description              = "The best client"
  access_type              = "CONFIDENTIAL"
  service_accounts_enabled = true
}

resource "keycloak_user" "test" {
  realm_id       = keycloak_realm.this.id
  username       = "test"
  email_verified = true
}

resource "keycloak_openid_client" "web" {
  realm_id              = keycloak_realm.this.id
  access_type           = "CONFIDENTIAL"
  client_id             = "web"
  standard_flow_enabled = true
  valid_redirect_uris   = ["http://localhost:4200"]
}

locals {
  roles = toset(["foo", "bar", "test"])
}

resource "keycloak_role" "test" {
  for_each  = local.roles
  realm_id  = keycloak_realm.this.id
  name      = each.value
  client_id = keycloak_openid_client.web.id
}

resource "keycloak_user_roles" "test" {
  realm_id = keycloak_realm.this.id
  role_ids = [for role in keycloak_role.test : role.id]
  user_id  = keycloak_user.test.id
}

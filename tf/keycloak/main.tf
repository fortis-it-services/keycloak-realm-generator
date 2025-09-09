resource "keycloak_realm" "this" {
  realm        = "awesome-realm"
  display_name = "Super Awesome Realm"
}

resource "keycloak_user" "test" {
  realm_id       = keycloak_realm.this.id
  username       = "test"
  email_verified = true
}

resource "keycloak_group" "test" {
  realm_id = keycloak_realm.this.id
  name     = "test"
}

resource "keycloak_group_memberships" "test" {
  realm_id = keycloak_realm.this.id
  group_id = keycloak_group.test.id
  members  = [keycloak_user.test.username]
}

module "client_a" {
  source     = "./modules/client"
  depends_on = [keycloak_group.test]

  realm_id                   = keycloak_realm.this.id
  client_id                  = "some_test"
  client_valid_redirect_uris = ["http://localhost:4200"]
  group_role_mappings = {
    test = ["a", "b", "c"]
  }
}

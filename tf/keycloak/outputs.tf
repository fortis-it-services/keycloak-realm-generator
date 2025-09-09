output "realm_name" {
  value       = keycloak_realm.this.realm
  description = "Name of the created realm"
}

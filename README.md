# Keycloak Realm Generator
Small utility to generate keycloak realms for testing purposes.

## Usage
Adjust your realm configuration via [terraform](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs)
at `tf/keycloak/main.tf` and simply run:
```shell
./create-realm-export.sh
```

Your exported realm will be at `volumes/keycloak/export/${REALM_NAME}.json`.
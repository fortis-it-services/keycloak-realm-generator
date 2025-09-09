#!/usr/bin/env bash

set -eEuo pipefail

REPOSITORY_ROOT="$(git rev-parse --show-toplevel)"

. "${REPOSITORY_ROOT}/.env"

function cleanup() {
    docker compose rm --force --stop
    rm "${REPOSITORY_ROOT}/tf/keycloak/terraform.tfstate"
}

trap cleanup EXIT

export KEYCLOAK_CLIENT_ID="admin-cli"
export KEYCLOAK_URL="http://localhost:${KC_HTTP_PORT}"
export KEYCLOAK_USER="${KC_BOOTSTRAP_ADMIN_USERNAME}"
export KEYCLOAK_PASSWORD="${KC_BOOTSTRAP_ADMIN_PASSWORD}"

docker compose up -d

printf "Waiting for keycloak to become ready "
until http --check-status --quiet ":${KC_MANAGEMENT_PORT}/health/ready" > /dev/null 2>&1; do
  printf "."
  sleep 1s
done

tofu -chdir="${REPOSITORY_ROOT}/tf/keycloak" init
tofu -chdir="${REPOSITORY_ROOT}/tf/keycloak" apply \
  -auto-approve

REALM_NAME=$(tofu -chdir="${REPOSITORY_ROOT}/tf/keycloak" output -raw realm_name)

docker compose exec \
  -e QUARKUS_HTTP_HOST_ENABLED=false \
  -e KC_HEALTH_ENABLED=false \
  keycloak /opt/keycloak/bin/kc.sh export --file "/export/${REALM_NAME}.json" --realm "${REALM_NAME}"

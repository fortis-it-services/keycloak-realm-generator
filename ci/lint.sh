#!/usr/bin/env bash

set -eEuo pipefail

REPOSITORY_ROOT="$(git rev-parse --show-toplevel)"

shellcheck \
  --external-sources \
  --enable=all \
  "${REPOSITORY_ROOT}"/**/*.sh

tofu -chdir="${REPOSITORY_ROOT}/tf/keycloak" fmt \
  -check \
  -recursive \
  -diff

tflint --chdir="${REPOSITORY_ROOT}/tf/keycloak"

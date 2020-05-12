#!/bin/bash
#
# Deploys a YAML-formatted zone definition to Cloud DNS.

set -euxo pipefail

_=${PROJECT:?Please provide PROJECT name in environment}
_=${DOMAIN:?Please provide DOMAIN name in environment}

ZONE="${DOMAIN/./-}"
ZONE_FILE="./${DOMAIN}.zone.yaml"

gcloud dns record-sets import "${ZONE_FILE}" \
    --zone "${ZONE}" \
    --delete-all-existing \
    --project "${PROJECT}"

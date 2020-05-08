#!/bin/bash

set -eux

_=${PROJECT:?Please provide PROJECT name in environment}
_=${DOMAIN:?Please provide DOMAIN name in environment}

# The maximum amount of time in seconds to wait for the zone file import
# operation to complete before exiting with an error.
MAX_IMPORT_WAIT="300"

ZONE_FILE="/workspace/${DOMAIN}"

# Remove the SOA record and any NS records.
sed -i -e '/IN[[:space:]]\+SOA/,+5 d' \
       -e '/IN[[:space:]]\+NS/ d' \
       $ZONE_FILE

# Deploy the zone to Cloud DNS
gcloud dns record-sets import "${ZONE_FILE}" \
    --zone-file-format \
    --zone "${DOMAIN/./-}" \
    --delete-all-existing \
    --project "${PROJECT}"


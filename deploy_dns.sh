#!/bin/bash
#
# A simple shell script to deploy a zone to Google Cloud DNS.

set -eux

_=${PROJECT:?Please provide PROJECT name in environment}
_=${DOMAIN:?Please provide DOMAIN name in environment}

ZONE_FILE="/workspace/${DOMAIN}"

# Remove the SOA record and any NS records.
# TODO(kinkade): Once the measurementlab.net zone has been migrated to Cloud
# DNS publicly, we can remove the SOA and NS records from the zone file and
# remove this sed command.
sed -i -e '/IN[[:space:]]\+SOA/,/^$/ d' \
       -e '/IN[[:space:]]\+NS/ d' \
       $ZONE_FILE

# Deploy the zone to Cloud DNS
gcloud dns record-sets import "${ZONE_FILE}" \
    --zone-file-format \
    --zone "${DOMAIN/./-}" \
    --delete-all-existing \
    --project "${PROJECT}"


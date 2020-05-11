#!/bin/bash
#
# Deploys a JSON-formatted zone definition to Cloud DNS.

set -euxo pipefail

_=${PROJECT:?Please provide PROJECT name in environment}
_=${DOMAIN:?Please provide DOMAIN name in environment}

ZONE="${DOMAIN/./-}"
ZONE_DATA="./${DOMAIN}.zone.json"
ZONE_FILE="./${DOMAIN}.zone.yaml"

IFS= read -r -d '' RR_TEMPLATE <<EOF || true
---
kind: dns#resourceRecordSet
name: {{NAME}}
rrdatas:
{{RRDATAS}}
ttl: {{TTL}}
type: {{TYPE}}
EOF

while IFS= read -r rr; do

  type=$(echo "$rr" | jq -r ".type")
  ttl=$(echo "$rr" | jq -r ".ttl")

  name=$(echo "$rr" | jq -r ".name")
  if [[ $name == "@" ]]; then
    name="${DOMAIN}."
  else
    name="${name}.${DOMAIN}."
  fi

  rrdatas=""
  while read -r rrdata; do
    if [[ $type == "TXT" ]]; then
      rrdatas+="- '\"${rrdata}\"'\n"
    else
      rrdatas+="- ${rrdata}\n"
    fi
  done < <(echo "$rr" | jq ".data" | jq -r ".[]")

  # Evaluate the template
  echo "${RR_TEMPLATE}" | sed \
      -e "s|{{NAME}}|${name}|" \
      -e "s|{{RRDATAS}}|${rrdatas}|" \
      -e "s|{{TTL}}|${ttl}|" \
      -e "s|{{TYPE}}|${type}|" \
      >> "${ZONE_FILE}"

done < <(jq --compact-output ".[]" "${ZONE_DATA}")

gcloud dns record-sets import "${ZONE_FILE}" \
    --zone "${ZONE}" \
    --delete-all-existing \
    --project "${PROJECT}"

rm -f "${ZONE_FILE}"

#!/bin/bash
#
# Ultra simple wrapper to 'mlabconfig.py --format=zone'

MLABCONFIG='operator/plsync/mlabconfig.py'
ZONE_HEADER='operator/plsync/mlabzone.header.in'
OUTPUT_FILE='measurement-lab.org'

$MLABCONFIG --format=zone --zoneheader=$ZONE_HEADER > $OUTPUT_FILE

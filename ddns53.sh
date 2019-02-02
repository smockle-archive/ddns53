#!/usr/bin/env bash
set -eo pipefail

# Get environment variables
if [ ! -f "$(dirname "$(readlink -f "$0")")/.env" ]; then
  echo "Missing .env file for ddns53. Exiting."
  exit 1
fi
export $(cat "$(dirname "$(readlink -f "$0")")/.env" | xargs)

# Get public IP address
IP_ADDRESS=$(dig +short myip.opendns.com @resolver1.opendns.com)
if [ -z $IP_ADDRESS ]; then
  echo "Could not get public IP address. Exiting."
  exit 1
fi 

# Set A record in the specified AWS Route 53 Hosted Zone
aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --cli-input-json "{ \"ChangeBatch\": { \"Comment\": \"Set A record to a specified value\", \"Changes\": [{ \"Action\": \"UPSERT\", \"ResourceRecordSet\": { \"Name\": \"${DOMAIN}\", \"Type\": \"A\", \"TTL\": 300, \"ResourceRecords\": [{ \"Value\": \"${IP_ADDRESS}\" }] } }] } }"
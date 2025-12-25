#!/bin/bash

ACME_FILE="./traefik/acme.json"
EXPECTED_PERMS="600"

echo "[Acme] Checking file $ACME_FILE..."
if [ ! -f "$ACME_FILE" ]; then
  echo "[Acme] File $ACME_FILE not found. create acme file..."
  echo "{}" > "$ACME_FILE"
  chmod "$EXPECTED_PERMS" "$ACME_FILE"
  echo "[Acme] File $ACME_FILE successfully created with content ‘{}’ and permissions $EXPECTED_PERMS."
else
  echo "[Acme] File $ACME_FILE found."
fi

echo "[Acme] Checking permissions file $ACME_FILE..."

CURRENT_PERMS=$(stat -c "%a" "$ACME_FILE")

if [ "$CURRENT_PERMS" != "$EXPECTED_PERMS" ]; then
  echo "[Acme] Permissions now: $CURRENT_PERMS (It should be: $EXPECTED_PERMS)."
  echo "[Acme] Change permissions to $EXPECTED_PERMS (-rw-------)..."
  chmod "$EXPECTED_PERMS" "$ACME_FILE"
  echo "[Acme] Permissions fix!."
else
  echo "[Acme] Permissions ($CURRENT_PERMS) correctly."
fi
#!/usr/bin/env bash

STORAGE_FOLDER="$HOME/.cache/pkg_versions"

if [ ! -d '.venv' ]; then
  echo "no venv in current folder"
  exit 1
fi

if [ ! -f 'token.json' ]; then
  echo "no google creds in current folder"
  exit 1
fi

if [ -z "$EMAIL" ]; then
  echo "EMAIL not set"
  exit 1
fi

if [ -z "$PACKAGE" ]; then
  echo "PACKAGE not set"
  exit 1
fi

if [ ! -d "$STORAGE_FOLDER" ]; then
  mkdir "$STORAGE_FOLDER"
fi

rmadison -b amd64 -a amd64 "$PACKAGE" | tr -d ' ' | awk -F'|' '{printf "%s: %s\n", $3, $2}' | sort > "/tmp/new_$PACKAGE"

if [ ! -f "$STORAGE_FOLDER/$PACKAGE" ]; then
  mv "/tmp/new_$PACKAGE" "$STORAGE_FOLDER/$PACKAGE"
  echo "new package data added"
  exit 0
fi

diff=$(diff -u "$STORAGE_FOLDER/$PACKAGE" "/tmp/new_$PACKAGE")

if [ -z "$diff" ]; then
  echo "no change detected"
  exit 0
fi

mv "/tmp/new_$PACKAGE" "$STORAGE_FOLDER/$PACKAGE"

.venv/bin/python send_email.py --to "$EMAIL" --message-text "$diff" --subject "New $PACKAGE released"

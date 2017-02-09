#!/usr/bin/env bash
SOURCE=${SOURCE:-""}
DESTINATION=${DESTINATION:-""}
DB=${DB:-""}
cp -R  /source/code/$SOURCE/* /destination/code/$DESTINATION

if [[ -n "$DB" ]]; then
  curl $DB > /tmp/db.gz
fi

sleep 5h




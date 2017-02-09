#!/usr/bin/env bash
SOURCE=${SOURCE:-""}
DESTINATION=${DESTINATION:-""}
DB=${DB:-""}

echo "Start initialization..."
cp -R  /source/code/$SOURCE/* /destination/code/$DESTINATION
echo "Source code copied"
if [[ -n "$DB" ]]; then
  echo "Fetching database..."
  curl $DB > /tmp/db.gz
  echo "Database fetched"
fi
echo "Sleeping...."
sleep 5h




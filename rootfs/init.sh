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
  echo "Importing database..."
  gzip -d < /tmp/db.gz | wp --path=/destination/code --allow-root db import -
  echo "Done"
fi



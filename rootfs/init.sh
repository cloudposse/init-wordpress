#!/usr/bin/env bash

GIT_REPO=${GIT_REPO:-""}
GIT_BRANCH=${GIT_BRANCH:-"master"}

DESTINATION=${DESTINATION:-""}
DB=${DB:-""}

mkdir -p /destination/code/$DESTINATION

if [[ -z "$GIT_REPO" ]]; then
  echo "GIT_REPO is not defined"
  exit 1
fi

echo "Start initialization..."

cd /destination/code/$DESTINATION
git clone --depth 1 $GIT_REPO ./
git checkout $GIT_BRANCH
rm -rf /destination/code/$DESTINATION/.git

echo "Source code copied"
if [[ -n "$DB" ]]; then
  echo "Fetching database..."
  curl $DB > /tmp/db.gz
  echo "Database fetched"
  echo "Importing database..."
  gzip -d < /tmp/db.gz | wp --path=/destination/code/$DESTINATION --allow-root db import -
  echo "Done"
fi



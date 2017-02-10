#!/usr/bin/env bash

set -o pipefail

GIT_REPO=${GIT_REPO:-""}
GIT_BRANCH=${GIT_BRANCH:-"master"}

DESTINATION=${DESTINATION:-""}
DB_URL=${DB:-""}

if [ -z "$GIT_REPO" ]; then
  echo "GIT_REPO is not defined"
  exit 1
fi

echo "Cloning ${GIT_REPO}#${GIT_BRANCH}..."
git clone --depth 1 -b ${GIT_BRANCH} ${GIT_REPO} ${DESTINATION}
if [ $? -ne 0 ]; then
  echo "Failed"
  exit 1
fi

cd $DESTINATION
rm -rf .git

if [ -n "$DB_URL" ]; then
  echo "Fetching database from ${DB_URL}..."
  curl --fail -s $DB > /tmp/db.gz
  if [ $? -ne 0 ]; then
    echo "Failed to download database"
    exit 1
  fi
  echo "Database fetched"
  echo "Importing database..."
  gzip -d < /tmp/db.gz | wp --path=/destination/code/$DESTINATION --allow-root db import -
  if [ $? -ne 0 ]; then
    echo "Failed to import database"
    exit 1
  fi
  echo "Done"
fi



#!/usr/bin/env bash

GIT_REPO=${GIT_REPO:-""}
GIT_BRANCH=${GIT_BRANCH:-"master"}

SOURCE=${SOURCE:-""}
DESTINATION=${DESTINATION:-""}
DB=${DB:-""}

mkdir -p /source/code
mkdir -p /destination/code

if [[ -z "$GIT_REPO" ]]; then
  echo "GIT_REPO is not defined"
  exit 1
fi

cd /source/code/
git clone --depth 1 $GIT_REPO
git checkout $GIT_BRANCH
rm -rf /source/code/$SOURCE/.git

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



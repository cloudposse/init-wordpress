#!/usr/bin/env bash

set -o pipefail

GIT_REPO_URL=${GIT_REPO_URL:-""}
GIT_BRANCH=${GIT_BRANCH:-"master"}

TGZ_URL=${TGZ_URL:-""}
TGZ_STRIP=${TGZ_STRIP:-1}

DESTINATION=${DESTINATION:-"/destination"}
DB_URL=${DB:-""}
DB_DUMP=${DB_DUMP:-/tmp/db.sql.gz}

if [ -n "$GIT_REPO_URL" ]; then
  echo "Cloning ${GIT_REPO_URL}#${GIT_BRANCH}..." | sed -E 's://[^@]+@://xxxxxxxx@:g'
  git clone --verbose --depth 1 -b "${GIT_BRANCH}" "${GIT_REPO_URL}" "${DESTINATION}"
  if [ $? -ne 0 ]; then
    echo "Failed"
    exit 1
  fi

  cd "${DESTINATION}"
  rm -rf .git
fi

if [ -n "$TGZ_URL" ]; then
  echo "Downloading ${TGZ_URL}..." | sed -E 's://[^@]+@://xxxxxxxx@:g'
  cd "${DESTINATION}"
  curl --location "${TGZ_URL}" | tar --strip ${TGZ_STRIP} -zvx
  if [ $? -ne 0 ]; then
    echo "Failed"
    exit 1
  fi
  rm -rf .git
fi

if [ -n "${DB_URL}" ]; then
  echo "Fetching database backup from ${DB_URL}..." | sed -E 's://[^@]+@://xxxxxxxx@:g'
  curl --fail -s "${DB_URL}" > "${DB_DUMP}"
  if [ $? -ne 0 ]; then
    echo "Failed to download database to ${DB_DUMP}"
    exit 1
  fi
  echo "Database backup saved to ${DB_DUMP}"
fi

if [ -f "${DB_DUMP}" ]; then
  echo "Importing database from ${DB_DUMP}..."
  gzip -d < "${DB_DUMP}" | wp --path=$DESTINATION --allow-root db import -
  if [ $? -ne 0 ]; then
    echo "Failed to import database"
    exit 1
  fi
  echo "Done"
fi

exit 0

#!/bin/bash

if [ ! -f "/usr/bin/imposm" ]; then
  echo "Imposm not found! Exiting."
  exit 0
fi

PGFILE=${1:-"__NONE__"}
DATABASE=${2:-"gis"}
USERNAME=${3:-"postgres"}
PASSWORD=${4:-""}



if [ "$PGFILE" == "__NONE__" ]; then
  echo "you need to specify a file to import"
  echo "./postgis.sh {pgfile} {database} {username} {password}"
  echo "defaults: pgfile=__NONE__, database=gis, username=postgres, password=postgres"
  echo "eg.: ./postgis.sh germany.osm.pbf geodatabase postgres postgres"
  exit 0
fi

USER_EXISTS=$(sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='$USERNAME'")
if [ "$USER_EXISTS" = '' ]; then
  echo "PostgreSQL user '$USERNAME' does not exist. Creating it."
  sudo -u postgres psql -c "CREATE USER $USERNAME;" > /dev/null 2>&1
  sudo -u postgres psql -c "ALTER ROLE $USERNAME SUPERUSER;" > /dev/null 2>&1
else
  echo "User '$USERNAME' exists. Continuing."
fi

DATABASE_EXISTS=$(sudo -u postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='$DATABASE'")
if [ "$DATABASE_EXISTS" = '' ]; then
  echo "PostgreSQL database '$DATABASE' does not exist. Creating it."
  sudo -u postgres psql -c "CREATE DATABASE $DATABASE;" > /dev/null 2>&1
  sudo -u postgres psql -d gis -c 'CREATE EXTENSION postgis; CREATE EXTENSION hstore;' > /dev/null 2>&1
else
  echo "Database '$DATABASE' exists. Continuing."
fi

echo "importing. this will take quiet a while. you might even be able to have a proper nap in the mean time."
imposm import -write -read $PGFILE -optimize -connection postgis://$USERNAME:$PASSWORD@localhost/$DATABASE \
              -mapping example-mapping.yml -overwritecache

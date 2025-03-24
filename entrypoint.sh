#!/bin/sh
set -e 

if [ -d "/mongo-dump" ]; then
  echo "Restoring dump from ./mongo-dump/ 💩"

  if [[ "$MONGO_DUMP_FILENAME" == *.archive ]]; then
    mongorestore --host mongodb --username $MONGO_USER --password $MONGO_PASS --authenticationDatabase admin --archive=/mongo-dump/${MONGO_DUMP_FILENAME}
  elif [[ "$MONGO_DUMP_FILENAME" == *.json ]]; then
    mongoimport --host mongodb --username $MONGO_USER --password $MONGO_PASS --authenticationDatabase admin --db $MONGO_DB_NAME --file /mongo-dump/${MONGO_DUMP_FILENAME} --jsonArray
  else
    mongorestore --host mongodb --username $MONGO_USER --password $MONGO_PASS --authenticationDatabase admin --db $MONGO_DB_NAME /mongo-dump
  fi

  if [ $? -ne 0 ]; then
    echo "Could not restore dump 💩"
    exit 1
  fi

  echo "Dump restored 💩"
else
  echo "Skipping - No database dump found 💩 "
fi

echo "Building site 🏗️"
pnpm build

echo "Starting server on 0.0.0.0:3000 🚀"
exec node .next/standalone/server.js

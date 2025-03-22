#!/bin/sh
set -e

printf 'Wating for database 🗄️'
until mongosh --host mongodb --quiet --eval "db.adminCommand('ping')" &>/dev/null; do
  printf ".";
  sleep 5
done
print "."


echo "Restoring dump ./mongo-dump/$MONGO_DUMP_FILENAME 💩"

if [[ "$MONGO_DUMP_FILENAME" == *.archive ]]; then
  mongorestore --host mongodb --username $MONGO_USER --password $MONGO_PASS --authenticationDatabase admin --archive=/mongo-dump/${MONGO_DUMP_FILENAME}
elif [[ "$MONGO_DUMP_FILENAME" == *.json ]]; then
  mongoimport --host mongodb --username $MONGO_USER --password $MONGO_PASS --authenticationDatabase admin --db $MONGO_DB_NAME --file /mongo-dump/${MONGO_DUMP_FILENAME} --jsonArray
else
  mongorestore --host mongodb --username $MONGO_USER --password $MONGO_PASS --authenticationDatabase admin --db $MONGO_DB_NAME /mongo-dump
fi

if [ $? -ne 0 ]; then
  echo "Could not restore data dump 💩"
  echo "Check logs with `docker compose logs` for more info 📄"
  exit 1
fi

echo "Dump restored 💩"

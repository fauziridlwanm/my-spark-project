#!/bin/bash
set -e

echo "--- Starting Docker containers (Jupyter, HDFS)... ---"
docker-compose up -d

echo ""
echo "--- Waiting 60 seconds for HDFS to initialize... ---"
sleep 60

echo ""
echo "--- Setting write permissions on notebooks folder... ---"
chmod -R 777 ~/my-spark-project/notebooks || true

echo ""
echo "--- Checking if local datasets exist... ---"
if [ ! -f data/trip.parquet ] || [ ! -f data/zone.csv ]; then
  echo "Some datasets missing, running downloader..."
  docker-compose run --rm downloader
else
  echo "Local datasets already exist. Skipping download."
fi

echo ""
echo "--- Uploading datasets to HDFS (root /) if not already present... ---"

docker-compose exec namenode hdfs dfs -test -e /trip.parquet \
  && echo "HDFS: /trip.parquet already exists — skipping put." \
  || docker-compose exec namenode hdfs dfs -put /data/trip.parquet /trip.parquet

docker-compose exec namenode hdfs dfs -test -e /zone.csv \
  && echo "HDFS: /zone.csv already exists — skipping put." \
  || docker-compose exec namenode hdfs dfs -put /data/zone.csv /zone.csv

echo ""
echo "--- Final container status: ---"
docker-compose ps

echo ""
echo "✅ All services are running. Jupyter available at http://localhost:8888"
echo "✅ Data available in HDFS under /datasets/"

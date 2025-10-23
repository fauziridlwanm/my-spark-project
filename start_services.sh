#!/bin/bash

echo "--- Starting Docker containers (Jupyter, HDFS)... ---"
docker-compose up -d

echo ""
echo "--- Waiting 60 seconds for HDFS to initialize... ---"
sleep 60

echo ""
echo "--- Setting write permissions on notebooks folder... ---"
chmod -R 777 ~/my-spark-project/notebooks

echo ""
echo "--- Downloading datasets into ./data (via downloader)... ---"
docker-compose run --rm downloader

echo ""
echo "--- Uploading datasets to HDFS (/datasets)... ---"
docker-compose exec namenode hdfs dfs -mkdir -p /datasets
docker-compose exec namenode hdfs dfs -put -f /data/trip.parquet /datasets/trip.parquet
docker-compose exec namenode hdfs dfs -put -f /data/zone.csv  /datasets/zone.csv

echo ""
echo "--- Final container status: ---"
docker-compose ps

echo ""
echo "✅ All services are running. Jupyter available at http://localhost:8888"
echo "✅ Data loaded into HDFS under /datasets/"


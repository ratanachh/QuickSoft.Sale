#!/bin/sh
set -e

echo "Packing data folder: " $PGDATA

cd /zdata/
tar -cf backup.tar -C $PGDATA ./
sync
rm -rf $PGDATA/*

echo "Pack & clean finished successfully."
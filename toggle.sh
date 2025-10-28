#!/bin/bash
set -eu

if [ ! -f .env ]; then
  echo ".env missing"
  exit 1
fi

CUR=$(grep '^ACTIVE_POOL=' .env | cut -d= -f2 || true)
if [ -z "$CUR" ]; then
  CUR=blue
fi

if [ "$CUR" = "blue" ]; then
  NEW=green
else
  NEW=blue
fi

# replace ACTIVE_POOL
sed -i "s/^ACTIVE_POOL=.*/ACTIVE_POOL=$NEW/" .env
echo "ACTIVE_POOL changed: $CUR -> $NEW"

# re-render nginx conf and reload nginx inside container
./render-and-start.sh
docker exec nginx_stage2 nginx -s reload
echo "nginx reloaded inside container"


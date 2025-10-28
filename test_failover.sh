#!/bin/bash
set -eu

MAIN="http://localhost:8080"
BLUE_CHAOS="http://localhost:8081/chaos/start?mode=error"
BLUE_CHAOS_STOP="http://localhost:8081/chaos/stop"

echo "Baseline GET /version"
curl -s -D - "$MAIN/version" | egrep -i 'HTTP/|X-App-Pool|X-Release-Id' || true

echo "Start chaos on blue (POST)"
curl -s -X POST "$BLUE_CHAOS" || true

echo "Polling main endpoint 20 times (0.5s wait)"
green=0
total=20
for i in $(seq 1 $total); do
  out=$(curl -s -D - "$MAIN/version" || true)
  echo "---- request $i ----"
  echo "$out" | egrep -i 'HTTP/|X-App-Pool|X-Release-Id' || true
  echo
  echo "$out" | grep -iq "X-App-Pool: green" && green=$((green+1)) || true
  sleep 0.5
done

echo "Green responses: $green / $total"
echo "Stopping chaos..."
curl -s -X POST "$BLUE_CHAOS_STOP" || true


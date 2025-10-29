#!/bin/sh
set -eu

# load env from .env if present
if [ -f .env ]; then
  # export variables from .env (simple parser)
  set -a
  . ./.env
  set +a
else
  echo ".env file missing. Copy .env.example to .env and edit values."
  exit 1
fi

# determine PRIMARY/SECONDARY based on ACTIVE_POOL
if [ "\${ACTIVE_POOL:-green}" = "green" ]; then
  export PRIMARY_HOST="app_green"
  export SECONDARY_HOST="app_blue"
else
  export PRIMARY_HOST="app_blue"
  export SECONDARY_HOST="app_green"
fi

# render template to nginx/nginx.conf
envsubst '\$PRIMARY_HOST \$SECONDARY_HOST \$APP_INTERNAL_PORT \$PROXY_CONNECT_TIMEOUT \$PROXY_SEND_TIMEOUT \$PROXY_READ_TIMEOUT \$PROXY_NEXT_UPSTREAM_TIMEOUT \$PROXY_NEXT_UPSTREAM_TRIES \$UPSTREAM_MAX_FAILS \$UPSTREAM_FAIL_TIMEOUT' \
  < nginx/nginx.conf.template > nginx/nginx.conf

echo "Rendered nginx/nginx.conf with PRIMARY_HOST=\$PRIMARY_HOST SECONDARY_HOST=\$SECONDARY_HOST"

# start docker compose
docker compose up -d
echo "Services started. Nginx exposed on http://localhost:\${NGINX_HOST_PORT} (on this host)."

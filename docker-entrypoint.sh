#!/usr/bin/env sh
set -eu

# Defaults (safe for local dev)
: "${PORT:=8080}"
: "${PROXY_PASS:=http://127.0.0.1:3000}"
: "${USERNAME:=user}"
: "${PASSWORD:=password}"

# Render nginx.conf from template with runtime env
envsubst '$PORT $PROXY_PASS' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# Build .htpasswd from env (overwrite each start)
# -B uses bcrypt on Alpine's htpasswd; fall back to -b if needed.
if command -v htpasswd >/dev/null 2>&1; then
  htpasswd -Bbc /etc/nginx/.htpasswd "$USERNAME" "$PASSWORD"
else
  echo "ERROR: htpasswd not found" >&2
  exit 1
fi

# Show where we're proxying (no secrets)
echo "Nginx listening on :$PORT → proxy_pass=$PROXY_PASS"

# Exec nginx in foreground (image sets daemon off by default)
exec nginx -g 'daemon off;'

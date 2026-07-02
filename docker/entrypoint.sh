#!/bin/sh
set -eu

if [ "$#" -gt 0 ]; then
    exec /bin/vproxy "$@"
fi

PORT="${PORT:-1080}"
PROXY_HOST="${PROXY_HOST:-0.0.0.0}"
VPROXY_LOG="${VPROXY_LOG:-info}"

set -- /bin/vproxy run --log "$VPROXY_LOG" --bind "${PROXY_HOST}:${PORT}" socks5

if [ "${PROXY_USERNAME:-}" ] || [ "${PROXY_PASSWORD:-}" ]; then
    if [ -z "${PROXY_USERNAME:-}" ] || [ -z "${PROXY_PASSWORD:-}" ]; then
        echo "Both PROXY_USERNAME and PROXY_PASSWORD must be set together." >&2
        exit 1
    fi

    set -- "$@" --username "$PROXY_USERNAME" --password "$PROXY_PASSWORD"
fi

exec "$@"

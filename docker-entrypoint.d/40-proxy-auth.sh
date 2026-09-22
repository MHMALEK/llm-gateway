#!/bin/sh
set -e
if [ -n "${OPENROUTER_API_KEY}" ]; then
    export PROXY_AUTHORIZATION="Bearer ${OPENROUTER_API_KEY}"
else
    # Kept as an nginx variable. The image entrypoint only substitutes
    # environment variables that are actually set.
    export PROXY_AUTHORIZATION='$http_authorization'
fi

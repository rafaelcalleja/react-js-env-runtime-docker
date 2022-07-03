#!/bin/sh

set -a
set -o errexit
set -o nounset

ENV_LIST="${ENV_LIST:-$(printenv | awk -F= '{print $1}' | sed 's/^/\$/g' | paste -sd,);}"
for file in "${NGINX_STATIC_JS_PATH:-/usr/share/nginx/html/static/}"/*.js;
do
  envsubst "${ENV_LIST}" < "$file" > "$file.tmp" && mv "$file.tmp" "$file"
done

unset NGINX_STATIC_JS_PATH
unset ENV_LIST

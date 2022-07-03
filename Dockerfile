ARG NODE_VERSION=${NODE_VERSION:-16}
FROM node:${NODE_VERSION} as node_deps

WORKDIR /app

COPY package.json yarn.lock /app/

RUN mkdir node_modules 2>/dev/null && \
    touch ./node_modules/.metadata_never_index

RUN yarn install --skip-integrity-check \
    --non-interactive \
    --no-node-version-check \
    --production \
    --ignore-platform \
    --no-progress

COPY src /app/src/
COPY public /app/public/

RUN (rm .env*|| true) && grep -R "process.env." src| \
    sed 's/^.*\(process.env.[a-zA-Z_0-9]*\).*$/\1/'| \
    egrep -v 'PUBLIC_URL'| \
    sort|uniq| \
    awk -F '.' '{print $3"=\"\${"$3"}\""}'| tee .env >/dev/null && \
    yarn run react-scripts build && rm .env

FROM nginx:stable-alpine
EXPOSE 80

COPY --from=node_deps /app/build /usr/share/nginx/html
COPY envsubst-react-environment.sh /docker-entrypoint.d/40-envsubst-react-environment.sh

ENV NGINX_STATIC_JS_PATH /usr/share/nginx/html/static/js

WORKDIR /usr/share/nginx/html

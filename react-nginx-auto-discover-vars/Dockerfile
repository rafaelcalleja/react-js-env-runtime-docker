FROM node:lts AS node_deps

WORKDIR /app

COPY package.json *package-lock.json *.npmrc yarn.lock ./

# install
ENV NODE_ENV production
RUN yarn install --production

COPY . /app

# save runtime variables as VAR=\${VAR} in .env file and create react app production build
RUN (rm .env*|| true) && grep -R "process.env." src| \
    sed 's/^.*\(process.env.[a-zA-Z_0-9]*\).*$/\1/'| \
    egrep -v 'PUBLIC_URL'| \
    sort|uniq| \
    awk -F '.' '{print $3"=\"\${"$3"}\""}'| tee .env >/dev/null && \
    yarn run react-scripts build && rm .env

FROM nginx:stable-alpine
EXPOSE 80
WORKDIR /usr/share/nginx/html

COPY --from=node_deps /app/build /usr/share/nginx/html

#add nginx entrypoint to replace environment variables in build js at runtime
COPY envsubst-react-environment.sh /docker-entrypoint.d/40-envsubst-react-environment.sh

#define env with static js files where find environment variables to replace
ENV NGINX_STATIC_JS_PATH /usr/share/nginx/html/static/js

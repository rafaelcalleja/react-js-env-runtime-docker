FROM node:lts AS node_deps

WORKDIR /app

COPY package.json *package-lock.json *.npmrc yarn.lock ./

# install
ENV NODE_ENV production
RUN yarn install --production

COPY . /app

# define runtime variables as VAR=\${VAR}
ENV REACT_APP_HELLO "\\\${REACT_APP_HELLO}"
ENV REACT_APP_WORLD "\\\${REACT_APP_WORLD}"

# create react app production build
RUN rm -f .env* ; \
    printenv > .env && \
    yarn build

FROM nginx:stable-alpine
EXPOSE 80

WORKDIR /usr/share/nginx/html
COPY --from=node_deps /app/build /usr/share/nginx/html

#create nginx entrypoint to replace environment variables in build js at runtime
RUN echo "\
export ENV_LIST=\"\$(printenv | awk -F= '{print $1}' | sed 's/^/\$/g' | paste -sd,)\"; \
find /usr/share/nginx/html/static/ -type f -name \"*.js\"| \
xargs -I % sh -c 'envsubst \"\${ENV_LIST}\" < \"%\" > \"%.tmp\" && mv \"%.tmp\" \"%\"'" \
> /docker-entrypoint.d/40-envsubst-react-environment.sh && chmod +x /docker-entrypoint.d/40-envsubst-react-environment.sh

### React
_src/index.js_
```js
const hello = process.env.REACT_APP_HELLO;
const world = process.env.REACT_APP_WORLD;

root.render(
    <h1>{ hello }, {world}</h1>
);
```

### docker

```bash
docker run -it --rm \
       -p 80:80 \
       -e REACT_APP_HELLO=runtime -e REACT_APP_WORLD=replace \
       docker.io/rafaelcalleja/react-app-hello-world:latest
```

### html render output

```
runtime, replace
```

### how it works - [Dockerfile](https://github.com/rafaelcalleja/react-js-env-runtime-docker/tree/master/react-nginx/Dockerfile)
#### create .env file during build phase setting value as environment variable name to later replace it using envsubst  
```Dockerfile
# define runtime variables as VAR=\${VAR}
ENV REACT_APP_HELLO "\\\${REACT_APP_HELLO}"
ENV REACT_APP_WORLD "\\\${REACT_APP_WORLD}"

# create react app production build
RUN rm -f .env* ; \
    printenv > .env && \
    yarn build
```

#### FROM nginx image create an entrypoint to replace text ${VAR} in builded js files using environment variables values with envsubst command at runtime 
```Dockerfile
#create nginx entrypoint to replace environment variables in build js at runtime
RUN echo "\
export ENV_LIST=\"\$(printenv | awk -F= '{print $1}' | sed 's/^/\$/g' | paste -sd,)\"; \
find /usr/share/nginx/html/static/ -type f -name \"*.js\"| \
xargs -I % sh -c 'envsubst \"\${ENV_LIST}\" < \"%\" > \"%.tmp\" && mv \"%.tmp\" \"%\"'" \
> /docker-entrypoint.d/40-envsubst-react-environment.sh && chmod +x /docker-entrypoint.d/40-envsubst-react-environment.sh
```
### kubernetes

_kubernetes/pod.yaml_
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: react-app
spec:
  containers:
    - name: web
      image: docker.io/rafaelcalleja/react-app-hello-world:latest
      env:
        - name: REACT_APP_HELLO
          value: "runtime"
        - name: REACT_APP_WORLD
          value: "replace"
      ports:
        - name: web
          containerPort: 80
          protocol: TCP 
```

```bash
kubectl -n test apply -f kubernetes/pod.yaml 
```

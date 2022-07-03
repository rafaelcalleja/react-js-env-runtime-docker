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

### html render output

```
runtime, replace
```
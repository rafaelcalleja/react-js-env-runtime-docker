### React
_src/index.js_
```
const hello = process.env.REACT_APP_HELLO;
const world = process.env.REACT_APP_WORLD;

root.render(
    <h1>{ hello }, {world}</h1>
);
```

### docker

```
docker run -it --rm \
       -p 80:80 \
       -e REACT_APP_HELLO=runtime -e REACT_APP_WORLD=replace
       react-app-production-build:latest
```

### kubernetes

_kubernetes/pod.yaml_
```
apiVersion: v1
kind: Pod
metadata:
  name: react-app
spec:
  containers:
    - name: web
      image: react-app-production-build:latest
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

```
kubectl -n test apply -f kubernetes/pod.yaml 
```

### html render output

```
runtime, replace
```
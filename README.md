This repo demonstrates:

- how to create/use lambda layers
- put a simple util.js into a layer, without creating a node modul

## Usage

create the lambda:
```
make create-fn
```

invoke it:
```
make invoke
```

after some code changes upload the new code zip:
```
make update-code
```

test it
```
make invoke
```

## Localstack

To test locally:
- we use a fake AWS env running in a container (localstack)
- install `awslocal` wrapper script which calls `aws` with correct --endpoint
- set `ENV=local`

```
make localstack-up
```

start fake aws in a container:
- lambda
- dynamodb
- s3

(for more config see: https://github.com/localstack/localstack#core-configurations)
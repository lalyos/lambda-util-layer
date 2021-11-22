fnName = yyy
region = --region us-east-1
#region = --region localhost

build: clean
	zip x.zip index.js
	zip layer.zip util.js

clean:
	rm -rf x x.zip

list-fn: env
	aws$(ENV) lambda list-functions $(region)  \
	| jq  -c '.Functions[]|[.FunctionName, .FunctionArn]'

env:
	@echo "---> ENV: '$(ENV)'"

create-fn: env build
	aws$(ENV) lambda create-function \
	  $(region) \
	  --function-name $(fnName) \
	  --runtime nodejs14.x \
	  --zip-file fileb://x.zip \
	  --handler index.handler \
	  --role arn:aws:iam::820221600447:role/efs-lambda-20-HelloWorldFunctionRole-XN4YJ7R54VOP

update-code: build
	aws$(ENV) lambda update-function-code \
	  $(region) \
	  --function-name $(fnName) \
	  --zip-file fileb://x.zip

upload-layer: build
	aws lambda publish-layer-version \
	  $(region) \
	  --layer-name util \
	  --zip-file fileb://layer.zip \
	  | tee resp.json

update-layer: upload-layer
	aws lambda update-function-configuration \
	  $(region) \
	  --function-name $(fnName) \
	  --layers $(shell jq .LayerVersionArn resp.json ) \


invoke: env
	@aws$(ENV) lambda invoke \
	  $(region) \
	  --function-name $(fnName) x
	@ echo "---> RESPONSE"
	@cat x


invoke-local:
	node index.js

localstack-up:
	docker-compose up -d

localstack-down:
	docker-compose down -t0

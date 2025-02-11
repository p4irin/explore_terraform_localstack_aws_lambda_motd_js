# Explore Terraform, AWS Lambda function MOTD Javascript on LocalStack

Deploy an AWS Lambda function in Javascript that

* returns a MOTD
* can be triggered through a function URL

Deploy

* manually with aws-cli
* automated with Terraform

## Code

The Javascript function returning a MOTD is in `index.js`

Zip this file into `motd.zip`

```bash
$ zip motd.zip index.js
```

## General steps

1. `$localstack start`
1. Create Lambda function
1. Create a function URL
1. `$localstack stop`

## AWS CLI

###

```bash
$ localstack start
```

### Create the Lambda function

```bash
$ aws --profile localstack lambda create-function \
--function-name motd \
--runtime nodejs18.x \
--zip-file fileb://motd.zip \
--handler index.handler \
--role arn:aws:iam::000000000000:role/lambda-role

{
    "FunctionName": "motd",
    ...
    "State": "Pending",
    "StateReason": "The function is being created.",
    ...
}
```

`"State": "Pending"` means you can't invoke the function yet. Calling the function in this state will result in following error

```bash
An error occurred (ResourceConflictException) when calling the Invoke operation: The operation cannot be performed at this time. The function is currently in the following state: Pending
```

You can check the state of the Lambda function

```bash
$ aws --profile localstack lambda get-function --function-name motd

{
    "FunctionName": "motd",
    ...
    "State": "Active",
    ...
}
```
If the state is `Active` we have a go.

Invoking the function

```bash
$ aws --profile localstack lambda invoke \
--function-name motd \
--payload '{"body": "{}"}' \
response.txt

{
    "StatusCode": 200,
    "ExecutedVersion": "$LATEST"
}
```

The response payload is in `response.txt`

```bash
$ cat response.txt|jq
{
  "statusCode": 200,
  "body": "{\"message\":\"Greetings! Don't forget to take a moment to appreciate the little things.\"}"
}
```

### Create a function URL

```bash
$ aws --profile localstack lambda create-function-url-config \
--function-name motd \
--auth-type none

{
    "FunctionUrl": "http://hpq6wbr7fr9o9ppsm0hk7nt2n3jlf17a.lambda-url.us-east-1.localhost.localstack.cloud:4566/",
    "FunctionArn": "arn:aws:lambda:us-east-1:000000000000:function:motd",
    "AuthType": "none",
    "CreationTime": "2025-02-09T14:55:58.934332+0000"
}
```

Use the url in `"FunctionUrl"` with curl to send a POST to that endpoint to trigger the lambda function.

```bash
$ function_url=$(aws --profile localstack lambda get-function-url-config --function-name motd|jq -r .FunctionUrl)
```

```bash
$ curl \
-X POST \
-H 'accept: application/json' \
-H 'content-type: application/json' \
-d '{"body": "{}"}' \
$function_url | jq

...
{
  "message": "Greetings! Don't forget to take a moment to appreciate the little things."
}
```

###

```bash
$ localstack stop
```

## Terraform

Refer to the `*.tf` files.

The order in which the resources are created conforms to the general steps. The function url resource references the lambda function resource. The lambda function resource is created first.

Init, plan and apply

```bash
$ localstack start
...
$ terraform init
...
$ terraform plan
...
$ terraform apply
...
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

function_url = "http://g8087feutw6diucqs5cvtq8l2svytrux.lambda-url.us-east-1.localhost.localstack.cloud:4566/"
```

An output variable shows the function url to use to trigger the lambda function.

```bash
$ localstack stop
```

## References

* [Resource: aws_lambda_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function)
* [Resource: aws_lambda_function_url](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function_url)
* [node.js](https://nodejs.org/en)
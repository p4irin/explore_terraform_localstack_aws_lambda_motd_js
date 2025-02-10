resource "aws_lambda_function" "motd" {
    filename = "motd.zip"
    function_name = "motd"
    runtime = "nodejs18.x"
    handler = "index.handler"
    role = "arn:aws:iam::000000000000:role/lambda-role"
}

resource "aws_lambda_function_url" "function_url" {
  function_name = aws_lambda_function.motd.function_name
  authorization_type = "NONE"
}

data "archive_file" "lambda_motd" {
  type = "zip"
  source_file = "${path.module}/index.js"
  output_path = "${path.module}/motd.zip"
}

resource "aws_lambda_function" "motd" {
    filename = "motd.zip"
    function_name = "motd"

    runtime = "nodejs18.x"
    handler = "index.handler"

    source_code_hash = data.archive_file.lambda_motd.output_base64sha256
    
    role = "arn:aws:iam::000000000000:role/lambda-role"
}

resource "aws_lambda_function_url" "function_url" {
  function_name = aws_lambda_function.motd.function_name
  authorization_type = "NONE"
}

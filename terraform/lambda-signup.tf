resource "aws_lambda_function" "signup" {
  function_name = "signup-function"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_signup.lambda_handler"
  runtime       = "python3.9"
  filename      = "lambda_signup.zip"
  source_code_hash = filebase64sha256("lambda_signup.zip")

  environment {
    variables = {
      COGNITO_USER_POOL_ID = aws_cognito_user_pool.user_pool.id
      COGNITO_CLIENT_ID    = aws_cognito_user_pool_client.user_pool_client.id
      DB_HOST              = var.db_host
      DB_NAME              = var.db_name
      DB_USER              = var.db_user
      DB_PASS              = var.db_pass
    }
  }

  vpc_config {
    subnet_ids         = data.terraform_remote_state.network.outputs.public_subnet_ids
    security_group_ids = [data.terraform_remote_state.network.outputs.aws_security_group_id]
  }

  depends_on = [aws_iam_role_policy_attachment.lambda_policy_attachment]
}

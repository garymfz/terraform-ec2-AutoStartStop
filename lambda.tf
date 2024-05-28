#Lambda Start Function#

#Lambda .py file
data "archive_file" "lambda_start" {
  type        = "zip"
  source_file = "./lambda_functions/ec2-start.py"
  output_path = "./lambda_functions/lambda_function_ec2start.zip"

}

#Lambda function
resource "aws_lambda_function" "ec2-start" {
  filename      = "./lambda_functions/lambda_function_ec2start.zip"
  function_name = "ec2-start"
  role          = aws_iam_role.EC2-Start-Stop-Role.arn
  handler       = "ec2-start.lambda_handler"

  source_code_hash = data.archive_file.lambda_start.output_base64sha256
  
  runtime = "python3.9"
  timeout = 10

    ephemeral_storage {
    size = 512 # Min 512 MB and the Max 10240 MB
  }

  environment {
    variables = {
      supertag = var.supertag
    }

}
}
#Lambda stop function#
#Lambda .py file
data "archive_file" "lambda_stop" {
  type        = "zip"
  source_file = "./lambda_functions/ec2-stop.py"
  output_path = "./lambda_functions/lambda_function_ec2stop.zip"
}
#Lambda function
resource "aws_lambda_function" "ec2-stop" {
  filename      = "./lambda_functions/lambda_function_ec2stop.zip"
  function_name = "ec2-stop"
  role          = aws_iam_role.EC2-Start-Stop-Role.arn
  handler       = "ec2-stop.lambda_handler"
  

  source_code_hash = data.archive_file.lambda_stop.output_base64sha256

  runtime = "python3.9"
  timeout = 10
    ephemeral_storage {
    size = 512 # Min 512 MB and the Max 10240 MB
  }
    environment {
    variables = {
      supertag = var.supertag
    }

}

}
#allows event bridge to invoke a lambda_function
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2-start.id
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ec2-start.arn
}

resource "aws_lambda_permission" "allow_cloudwatchstop" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2-stop.id
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ec2-stop.arn
}
data "archive_file" "lambda_start" {
  type        = "zip"
  source_file = "${path.module}/lambda_functions/ec2_start.py"
  output_path = "${path.root}/.terraform/${var.name_prefix}-ec2-start.zip"
}

resource "aws_lambda_function" "ec2_start" {
  filename      = data.archive_file.lambda_start.output_path
  function_name = "${var.name_prefix}-start"
  role          = aws_iam_role.ec2_start_stop.arn
  handler       = "ec2_start.lambda_handler"
  runtime       = var.lambda_runtime
  timeout       = var.lambda_timeout

  source_code_hash = data.archive_file.lambda_start.output_base64sha256

  ephemeral_storage {
    size = 512
  }

  environment {
    variables = {
      supertag = var.supertag
      tagvalue = var.tag_value
    }
  }

  tags = var.tags
}

data "archive_file" "lambda_stop" {
  type        = "zip"
  source_file = "${path.module}/lambda_functions/ec2_stop.py"
  output_path = "${path.root}/.terraform/${var.name_prefix}-ec2-stop.zip"
}

resource "aws_lambda_function" "ec2_stop" {
  filename      = data.archive_file.lambda_stop.output_path
  function_name = "${var.name_prefix}-stop"
  role          = aws_iam_role.ec2_start_stop.arn
  handler       = "ec2_stop.lambda_handler"
  runtime       = var.lambda_runtime
  timeout       = var.lambda_timeout

  source_code_hash = data.archive_file.lambda_stop.output_base64sha256

  ephemeral_storage {
    size = 512
  }

  environment {
    variables = {
      supertag = var.supertag
      tagvalue = var.tag_value
    }
  }

  tags = var.tags
}

resource "aws_lambda_permission" "allow_eventbridge_start" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2_start.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ec2_start.arn
}

resource "aws_lambda_permission" "allow_eventbridge_stop" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2_stop.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ec2_stop.arn
}

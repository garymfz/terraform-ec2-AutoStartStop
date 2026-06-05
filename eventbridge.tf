resource "aws_cloudwatch_event_rule" "ec2_start" {
  name                = "${var.name_prefix}-start"
  description         = "Starts EC2 instances selected by ${var.supertag}=${var.tag_value}."
  schedule_expression = var.cronstart

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "lambda_start" {
  target_id = "${var.name_prefix}-start"
  rule      = aws_cloudwatch_event_rule.ec2_start.name
  arn       = aws_lambda_function.ec2_start.arn
}

resource "aws_cloudwatch_event_rule" "ec2_stop" {
  name                = "${var.name_prefix}-stop"
  description         = "Stops EC2 instances selected by ${var.supertag}=${var.tag_value}."
  schedule_expression = var.cronstop

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "lambda_stop" {
  target_id = "${var.name_prefix}-stop"
  rule      = aws_cloudwatch_event_rule.ec2_stop.name
  arn       = aws_lambda_function.ec2_stop.arn
}

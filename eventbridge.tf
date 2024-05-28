#creates an eventbridge rule to make the lambdas work

#eventbridge rule for start ec2
resource "aws_cloudwatch_event_rule" "ec2-start" {
  name        = "ec2-autostart"
  description = "starts ec2-instances tagged with var.supertag"
  schedule_expression = var.cronstart
}
resource "aws_cloudwatch_event_target" "lambda"{
  target_id = "ec2-start"
  rule      = aws_cloudwatch_event_rule.ec2-start.name
  arn       = aws_lambda_function.ec2-start.arn
}

#eventbridge rule for auto-stop ec2
resource "aws_cloudwatch_event_rule" "ec2-stop" {
  name        = "ec2-autostop"
  description = "stops ec2-instances tagged with var.supertag"
  schedule_expression = var.cronstop
}
resource "aws_cloudwatch_event_target" "lambda2"{
  target_id = "ec2-stop"
  rule      = aws_cloudwatch_event_rule.ec2-stop.name
  arn       = aws_lambda_function.ec2-stop.arn
}



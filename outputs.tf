output "start_lambda_function_name" {
  description = "Name of the Lambda function that starts EC2 instances."
  value       = aws_lambda_function.ec2_start.function_name
}

output "stop_lambda_function_name" {
  description = "Name of the Lambda function that stops EC2 instances."
  value       = aws_lambda_function.ec2_stop.function_name
}

output "iam_role_arn" {
  description = "ARN of the IAM role used by both Lambda functions."
  value       = aws_iam_role.ec2_start_stop.arn
}

output "start_event_rule_arn" {
  description = "ARN of the EventBridge rule that triggers the start Lambda."
  value       = aws_cloudwatch_event_rule.ec2_start.arn
}

output "stop_event_rule_arn" {
  description = "ARN of the EventBridge rule that triggers the stop Lambda."
  value       = aws_cloudwatch_event_rule.ec2_stop.arn
}

variable "name_prefix" {
  description = "Prefix used for all resources created by this module."
  type        = string
  default     = "ec2-auto-start-stop"
}

variable "cronstart" {
  description = "EventBridge schedule expression used to start EC2 instances. Times are evaluated in UTC unless a scheduler timezone is configured outside this module."
  type        = string
}

variable "cronstop" {
  description = "EventBridge schedule expression used to stop EC2 instances. Times are evaluated in UTC unless a scheduler timezone is configured outside this module."
  type        = string
}

variable "supertag" {
  description = "EC2 DescribeInstances filter name used to select instances, for example tag:auto-start-stop."
  type        = string
  default     = "tag:auto-start-stop"
}

variable "tag_value" {
  description = "Tag value that selected EC2 instances must have."
  type        = string
  default     = "true"
}

variable "lambda_runtime" {
  description = "Python runtime used by the Lambda functions."
  type        = string
  default     = "python3.12"
}

variable "lambda_timeout" {
  description = "Timeout in seconds for each Lambda function."
  type        = number
  default     = 10
}

variable "tags" {
  description = "Tags applied to supported AWS resources."
  type        = map(string)
  default     = {}
}

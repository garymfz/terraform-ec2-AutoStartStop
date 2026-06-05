# Terraform EC2 Auto Start/Stop

Terraform module that creates a scheduled EC2 start/stop automation using AWS Lambda and EventBridge.

The module deploys:

- Two Lambda functions: one starts instances, one stops instances.
- Two EventBridge schedule rules.
- EventBridge targets and Lambda invoke permissions.
- One IAM role with EC2 start/stop/describe permissions and basic Lambda logging permissions.

Instances are selected by an EC2 tag filter. By default, the module targets instances tagged:

```text
auto-start-stop = true
```

## Usage

Configure the AWS provider in your root Terraform project, then call this module.

```hcl
provider "aws" {
  region  = "eu-west-1"
  profile = "my-aws-profile"
}

module "ec2_auto_start_stop" {
  source = "git::https://github.com/garymfz/terraform-ec2-AutoStartStop.git"

  name_prefix = "dev-ec2-scheduler"
  cronstart   = "cron(25 6 ? * MON-FRI *)"
  cronstop    = "cron(0 22 ? * MON-FRI *)"

  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
```

For a local checkout:

```hcl
module "ec2_auto_start_stop" {
  source = "../terraform-ec2-AutoStartStop"

  cronstart = "cron(25 6 ? * MON-FRI *)"
  cronstop  = "cron(0 22 ? * MON-FRI *)"
}
```

## Tagging EC2 Instances

Add this tag to each EC2 instance that should be managed:

```text
auto-start-stop = true
```

The Lambda functions search for instances using the EC2 `DescribeInstances` filter `tag:auto-start-stop` with value `true`.

To use another tag key or value:

```hcl
module "ec2_auto_start_stop" {
  source = "../terraform-ec2-AutoStartStop"

  cronstart = "cron(25 6 ? * MON-FRI *)"
  cronstop  = "cron(0 22 ? * MON-FRI *)"
  supertag  = "tag:schedule"
  tag_value = "office-hours"
}
```

Then tag instances with:

```text
schedule = office-hours
```

## Schedule Expressions

`cronstart` and `cronstop` use EventBridge schedule expressions.

Example:

```hcl
cronstart = "cron(25 6 ? * MON-FRI *)"
cronstop  = "cron(0 22 ? * MON-FRI *)"
```

EventBridge cron expressions are evaluated in UTC. The example above starts instances Monday to Friday at 06:25 UTC and stops them Monday to Friday at 22:00 UTC.

## Requirements

| Name | Version |
| --- | --- |
| Terraform | >= 1.3.0 |
| AWS provider | >= 5.0.0 |
| Archive provider | >= 2.4.0 |

## Providers

This module declares required providers, but it does not configure them. Configure the AWS provider in the root module that calls this module.

## Inputs

| Name | Description | Type | Default | Required |
| --- | --- | --- | --- | --- |
| `cronstart` | EventBridge schedule expression used to start EC2 instances. | `string` | n/a | yes |
| `cronstop` | EventBridge schedule expression used to stop EC2 instances. | `string` | n/a | yes |
| `lambda_runtime` | Python runtime used by the Lambda functions. | `string` | `"python3.12"` | no |
| `lambda_timeout` | Timeout in seconds for each Lambda function. | `number` | `10` | no |
| `name_prefix` | Prefix used for all resources created by this module. | `string` | `"ec2-auto-start-stop"` | no |
| `supertag` | EC2 DescribeInstances filter name used to select instances. | `string` | `"tag:auto-start-stop"` | no |
| `tag_value` | Tag value that selected EC2 instances must have. | `string` | `"true"` | no |
| `tags` | Tags applied to supported AWS resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| --- | --- |
| `iam_role_arn` | ARN of the IAM role used by both Lambda functions. |
| `start_event_rule_arn` | ARN of the EventBridge rule that triggers the start Lambda. |
| `start_lambda_function_name` | Name of the Lambda function that starts EC2 instances. |
| `stop_event_rule_arn` | ARN of the EventBridge rule that triggers the stop Lambda. |
| `stop_lambda_function_name` | Name of the Lambda function that stops EC2 instances. |

## IAM Permissions

The Lambda role can:

- Describe EC2 instances.
- Start EC2 instances.
- Stop EC2 instances.
- Write basic Lambda logs to CloudWatch Logs.

The EC2 actions currently use `Resource = "*"`, because EC2 `DescribeInstances` does not support resource-level scoping and start/stop permissions are commonly constrained with tags in the calling account's IAM strategy if stricter governance is required.

## Notes

- The module intentionally does not include a provider block or backend configuration. Those belong in the root Terraform project.
- Lambda deployment packages are generated with the `archive` provider during Terraform execution.
- The module only starts or stops instances matching the configured tag filter and value.

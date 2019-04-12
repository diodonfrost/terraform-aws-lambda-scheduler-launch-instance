# terraform-aws-lambda-scheduler-launch-instance

Terraform module which create lambda scheduler for launch ec2 instance on AWS

## Features

*   Aws lambda runtine Python 3.7
*   ec2 instances scheduling

## Usage
```hcl
module "aws-run-instance-everyday" {
  source                         = "../.."
  name                           = "run-instance"
  cloudwatch_schedule_expression = "cron(0 23 ? * FRI *)"

  instance_params = {
    ami_id        = "ami-07683a44e80cd32c5"
    instance_type = "t2.micro"
    keypair       = "my-little-key"
    security_grp  = "my-little-security-group"
    user_data     = "yum install ansible -y"
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | Define name to use for lambda function, cloudwatch event and iam role | string | n/a | yes |
| cloudwatch_schedule_expression | The scheduling expression | string | `"cron(0 22 ? * MON-FRI *)"` | yes |
| instance_params | Define ec2 instance params | map | n/a | yes |
| instance_user_data | Define ec2 instance user data | string | `echo test > /tmp/test.txt` | yes |


## Outputs

| Name | Description |
|------|-------------|
| scheduler_lambda_arn | The Amazon Resource Name (ARN) identifying your Lambda Function |
| lambda_iam_role_name | The name of the IAM role used by Lambda function |
| scheduler_lambda_arn | The ARN of the Lambda function |
| scheduler_function_name | The name of the Lambda function |
| scheduler_lambda_invoke_arn | The ARN to be used for invoking Lambda function from API Gateway |
| scheduler_lambda_function_last_modified | The date Lambda function was last modified |
| scheduler_lambda_function_version | Latest published version of your Lambda function |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Tests

This module has been packaged with [awspec](https://github.com/k1LoW/awspec) tests through test kitchen. To run them:

Install kitchen-terraform and awspec:

```shell
# Install dependencies
gem install bundler
bundle install
```

Launch kitchen tests:

```shell
# List all tests with kitchen
kitchen list

# Build, and tests terraform module
kitchen test lambda-scheduler-aws

# for development, create environment
kitchen converge lambda-scheduler-aws

# Apply awspec tests
kitchen verify lambda-scheduler-aws
```


## Authors

Modules managed by [diodonfrost](https://github.com/diodonfrost)

## Licence

Apache 2 Licensed. See LICENSE for full details.

## Resources

*   [cloudwatch schedule expressions](https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html)
*   [Python boto3 ec2](https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/ec2.html)

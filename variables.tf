# Terraform variables file

# Set cloudwatch events for shutingdown instances
# trigger lambda functuon every night at 22h00 from Monday to Friday
# cf doc : https://docs.aws.amazon.com/lambda/latest/dg/tutorial-scheduled-events-schedule-expressions.html
variable "cloudwatch_schedule_expression" {
  type        = "string"
  description = "Define the aws cloudwatch event rule schedule expression"
  default     = "cron(0 22 ? * MON-FRI *)"
}

variable "name" {
  type        = "string"
  description = "Define name to use for lambda function, cloudwatch event and iam role"
}

variable "instance_params" {
  type        = "map"
  description = "Define ec2 instance params"

  default = {
    ami_id        = "ami-07683a44e80cd32c5"
    instance_type = "t2.micro"
    keypair       = "my-little-key"
    security_grp  = "my-little-security-group"
    user_data     = "echo test > /tmp/test.txt"
  }
}

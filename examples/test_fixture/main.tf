# Deploy two lambda for testing with awspec

module "aws-run-instance-everyday" {
  source                         = "../.."
  name                           = "run-instance"
  cloudwatch_schedule_expression = "cron(0 23 ? * FRI *)"

  instance_params = {
    ami_id        = "ami-07683a44e80cd32c5"
    instance_type = "t2.micro"
    keypair       = "my-little-key"
    security_grp  = "my-little-security-group"
  }
}

# Deploy two lambda for testing with awspec

module "aws-launch-instance-from-monday-to-friday" {
  source                         = "../.."
  name                           = "launch-instance"
  cloudwatch_schedule_expression = "cron(0 07 ? * MON-FRI *)"

  instance_params = {
    ami_id        = "ami-07683a44e80cd32c5"
    instance_type = "t2.micro"
    keypair       = "my-little-key"
    security_grp  = "my-little-security-group"
    user_data     = "yum install ansible -y && yum insall -y vim"
  }
}

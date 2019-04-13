# Deploy two lambda for testing with awspec

module "launch-my-instance-from-monday-to-friday" {
  source                         = "../.."
  name                           = "launch-instance"
  cloudwatch_schedule_expression = "cron(0 07 ? * MON-FRI *)"

  instance_params = {
    ami_id        = "ami-07683a44e80cd32c5"
    instance_type = "t2.micro"
    keypair       = "ippon-df"
    security_grp  = "my-little-security-group"

    # Value must be in base64
    user_data = "IyEvdXNyL2Jpbi9lbnYgYmFzaAplY2hvIHRlc3QgPiAvdG1wL3Rlc3QudHh0CmFtYXpvbi1saW51eC1leHRyYXMgaW5zdGFsbCAteSBhbnNpYmxlMgp5dW0gaW5zdGFsbCAteSBubWFwCgo="
  }
}

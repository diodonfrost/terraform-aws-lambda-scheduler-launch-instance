# Deploy two lambda for testing with awspec

module "aws-launch-my-instance" {
  source                         = "../.."
  name                           = "launch-my-instance"
  cloudwatch_schedule_expression = "cron(0 07 ? * MON-FRI *)"

  instance_params = {
    ami_id        = "ami-07683a44e80cd32c5"
    instance_type = "t2.micro"
    keypair       = "my-little-key"
    security_grp  = "my-little-security-group"

    # Value must be in base64
    user_data = "IyEvdXNyL2Jpbi9lbnYgYmFzaAplY2hvIHRlc3QgPiAvdG1wL3Rlc3QudHh0CmFtYXpvbi1saW51eC1leHRyYXMgaW5zdGFsbCAteSBhbnNpYmxlMgp5dW0gaW5zdGFsbCAteSBubWFwCgo="
  }
}

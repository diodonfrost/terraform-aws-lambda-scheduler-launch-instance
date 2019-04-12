################################################
#
#            IAM CONFIGURATION
#
################################################

# Create role for stop and start aws resouces
resource "aws_iam_role" "scheduler_instance" {
  name        = "${var.name}-scheduler-instance"
  description = "Allows instance functions to run ec2 instance"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Create custom policy for run ec2 instances
resource "aws_iam_policy" "schedule_ec2" {
  name        = "${var.name}-ec2-custom-policy-scheduler"
  description = "allow to run ec2 instances"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Action": [
            "ec2:RunInstances"
        ],
        "Resource": "*",
        "Effect": "Allow"
    }
  ]
}
EOF
}

# Attach custom policy ec2 to role
resource "aws_iam_role_policy_attachment" "ec2" {
  role       = "${aws_iam_role.scheduler_instance.name}"
  policy_arn = "${aws_iam_policy.schedule_ec2.arn}"
}

################################################
#
#            SECURITY GROUP
#
################################################

resource "aws_security_group" "allow_http_https" {
  name        = "${var.instance_params["security_grp"]}"
  description = "Allow http and https inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

################################################
#
#            LAMBDA FUNCTION
#
################################################

# Convert *.py to .zip because AWS instance need .zip
data "archive_file" "convert_py_to_zip" {
  type        = "zip"
  source_dir  = "${path.module}/package/"
  output_path = "${path.module}/aws-run-instance.zip"
}

# Create instance function for stop or start aws resources
resource "aws_lambda_function" "run_instance" {
  filename         = "${data.archive_file.convert_py_to_zip.output_path}"
  function_name    = "${var.name}"
  role             = "${aws_iam_role.scheduler_instance.arn}"
  handler          = "main.lambda_handler"
  source_code_hash = "${data.archive_file.convert_py_to_zip.output_base64sha256}"
  runtime          = "python3.7"
  timeout          = "600"

  environment {
    variables = {
      ami_id        = "${var.instance_params["ami_id"]}"
      instance_type = "${var.instance_params["instance_type"]}"
      keypair       = "${var.instance_params["keypair"]}"
      security_grp  = "${var.instance_params["security_grp"]}"
      user_data     = "${var.instance_user_data}"
    }
  }
}

################################################
#
#            CLOUDWATCH EVENT
#
################################################

# Create event cloud watch for trigger instance scheduler
resource "aws_cloudwatch_event_rule" "instance_event" {
  name                = "trigger-instance-scheduler-${var.name}"
  description         = "Trigger instance scheduler"
  schedule_expression = "${var.cloudwatch_schedule_expression}"
}

# Set instance function as target
resource "aws_cloudwatch_event_target" "instance_event_target" {
  arn  = "${aws_lambda_function.run_instance.arn}"
  rule = "${aws_cloudwatch_event_rule.instance_event.name}"
}

# Allow cloudwatch to invoke instance scheduler
resource "aws_lambda_permission" "allow_cloudwatch_scheduler" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  principal     = "events.amazonaws.com"
  function_name = "${aws_lambda_function.run_instance.function_name}"
  source_arn    = "${aws_cloudwatch_event_rule.instance_event.arn}"
}

# aws spec testing lambda event cloudwatch

require 'awspec'
require 'aws-sdk'
require 'rhcl'

cloudwatch_name = 'trigger-instance-scheduler-launch-my-instance'

describe cloudwatch_event(cloudwatch_name) do
  it { should exist }
  it { should be_enable }
end

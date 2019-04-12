# aws spec testing iam lambda sheduler

require 'awspec'
require 'aws-sdk'
require 'rhcl'

role_name = 'launch-my-instance-scheduler-instance'

describe iam_role(role_name) do
  it { should exist }
  its('attached_policies.count') { should eq 1 }
end

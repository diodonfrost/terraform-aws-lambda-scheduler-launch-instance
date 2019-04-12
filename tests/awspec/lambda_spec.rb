# aws spec testing lambda functions

require 'awspec'
require 'aws-sdk'
require 'rhcl'

lambda_name = 'launch-my-instance'

# Lambda function should be created
describe lambda(lambda_name) do
  it { should exist }
  its(:timeout) { should be >= 600 }
  its(:runtime) { should eq 'python3.7' }
end

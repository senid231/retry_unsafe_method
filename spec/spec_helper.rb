require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'bundler/setup'
Bundler.setup

require 'retry_unsafe_method'

# RSpec.configure do |config|
#   some (optional) config here
# end
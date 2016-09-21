source 'https://rubygems.org'

# Specify your gem's dependencies in retry_unsafe_method.gemspec
gemspec

group :test do
  gem 'codeclimate-test-reporter', require: nil

  platform :ruby_18, :ruby_19 do
    gem 'simplecov', '>= 0.10', '< 0.12', require: nil
  end
end

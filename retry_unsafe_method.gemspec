# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'retry_unsafe_method/version'

Gem::Specification.new do |spec|
  spec.name = 'retry_unsafe_method'
  spec.version = RetryUnsafeMethod::VERSION
  spec.authors = ['Denis Talakevich']
  spec.email = ['senid231@gmail.com']

  spec.summary = 'Allow to retry unsafe methods.'
  spec.description = 'Allow to retry unsafe methods.'
  spec.homepage = 'https://github.com/senid231/retry_unsafe_method'
  spec.license = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.8.9'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'activesupport', '~> 4.0'
end

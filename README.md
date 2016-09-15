# RetryUnsafeMethod
### Status
[![Build Status](https://travis-ci.org/senid231/retry_unsafe_method.png)](https://travis-ci.org/senid231/retry_unsafe_method)

Allow easily make methods retriable

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'retry_unsafe_method'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install retry_unsafe_method

## Usage

include module to your class
``

and add after method definition

`retry_unsafe_method <method_name>, <retries_qty>, *<exceptions>`

or

`retry_unsafe_method <method_name>, <retries_qty>, &<block>`

```ruby
require 'retry_unsafe_method'

class SomeError < StandardError
end

class A
  include RetryUnsafeMethod::RetryUnsafeMethod
  
  def some_method
    # can raise SomeError
  end
  
  retry_unsafe_method :some_method, 2, SomeError
  # or
  retry_unsafe_method :some_method, 2 do |e|
    e.is_a?(SomeError)
  end
  
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/senid231/retry_unsafe_method.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


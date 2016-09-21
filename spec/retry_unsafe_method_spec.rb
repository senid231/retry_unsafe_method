require 'spec_helper'
require 'custom_helper'
require 'active_support/core_ext/string/inflections'

describe RetryUnsafeMethod::RetryUnsafeMethod do
  let(:tested_class_object) { "#{tested_class_namespace}::#{tested_class}".constantize }
  let(:tested_instance) { tested_class_object.new(fail_qty, exception_class) }
  let(:tested_method) { RetryUnsafeSpec::TESTED_METHOD }
  let(:expected_success_result) { [RetryUnsafeSpec::SUCCESS_RESULT] }


  # SHARED EXAMPLES
  shared_examples :tested_method_is_public do
    it 'tested method is public' do
      expect(tested_class_object.public_method_defined?(tested_method)).to be_truthy
    end
  end

  shared_examples :tested_method_is_private do
    it 'tested method is public' do
      expect(tested_class_object.private_method_defined?(tested_method)).to be_truthy
    end
  end

  shared_examples :tested_method_is_protected do
    it 'tested method is public' do
      expect(tested_class_object.protected_method_defined?(tested_method)).to be_truthy
    end
  end

  shared_examples :retriable_method_succeeds do
    it 'does not raise error' do
      expect { subject }.to_not raise_error
    end

    it 'returns success' do
      expect(subject).to eq expected_success_result
    end

  end # shared_examples :retriable_method_succeeds

  shared_examples :retriable_method_fails do
    it 'raises exception' do
      expect { subject }.to raise_error(exception_class, 'rspec')
    end

  end # shared_examples :retriable_method_fails

  shared_examples :correct_behaviour_of_retry_unsafe_method do
    let(:fail_qty) { RetryUnsafeSpec::RETRY_QTY }
    let(:exception_class) { RetryUnsafeSpec::TestError }

    context 'with correct retry qty and correct error class' do
      include_examples :retriable_method_succeeds
    end

    context 'with correct retry qty and correct error class' do
      let(:fail_qty) { RetryUnsafeSpec::RETRY_QTY - 1 }
      include_examples :retriable_method_succeeds
    end

    context 'with smaller retry qty and correct error class' do
      let(:fail_qty) { RetryUnsafeSpec::RETRY_QTY + 1 }
      include_examples :retriable_method_fails
    end

    context 'with correct retry qty and another error class' do
      let(:exception_class) { RetryUnsafeSpec::AnotherError }
      include_examples :retriable_method_fails
    end

  end # shared_examples :correct_behaviour_of_retry_unsafe_method

  shared_examples :correct_behaviour_with_any_args_and_block do |additional_shared_example|

    describe 'without arguments and without block' do
      subject do
        tested_instance.__send__(tested_method)
      end

      let(:tested_class) { 'NoArgsNoBlock' }
      include_examples :correct_behaviour_of_retry_unsafe_method
      include_examples additional_shared_example
    end

    describe 'with arguments and without block' do
      subject do
        tested_instance.__send__(tested_method, 1, 2, 3)
      end

      let(:expected_success_result) { super() + [1, 2, 3] }
      let(:tested_class) { 'WithArgsNoBlock' }
      include_examples :correct_behaviour_of_retry_unsafe_method
    end

    describe 'without arguments and with block' do
      subject do
        tested_instance.__send__(tested_method) { 'test' }
      end

      let(:expected_success_result) { super() + ['test'] }
      let(:tested_class) { 'NoArgsWithBlock' }
      include_examples :correct_behaviour_of_retry_unsafe_method
    end

    describe 'with arguments and with block' do
      subject do
        tested_instance.__send__(tested_method, 1, 2, 3) { 'test' }
      end

      let(:expected_success_result) { super() + [1, 2, 3, 'test'] }
      let(:tested_class) { 'WithArgsWithBlock' }
      include_examples :correct_behaviour_of_retry_unsafe_method
    end

  end # shared_examples :correct_behaviour_with_any_args_and_block

  shared_context :stub_expectation_kernel_sleep do
    before do
      expect(tested_instance).to receive(:sleep).with(RetryUnsafeSpec::WAIT_SECONDS).at_most(RetryUnsafeSpec::RETRY_QTY).times
    end
  end # shared_context :stub_expectation_kernel_sleep


  # TESTS


  context 'when method is public' do
    let(:tested_class_namespace) { 'RetryUnsafeSpec::WithPublic' }

    before { expect(tested_instance).to_not receive(:sleep) }

    include_examples :correct_behaviour_with_any_args_and_block, :tested_method_is_public
  end


  context 'when method is private' do
    let(:tested_class_namespace) { 'RetryUnsafeSpec::WithPrivate' }

    before { expect(tested_instance).to_not receive(:sleep) }

    include_examples :correct_behaviour_with_any_args_and_block, :tested_method_is_private
  end


  context 'when method is protected' do
    let(:tested_class_namespace) { 'RetryUnsafeSpec::WithProtected' }

    before { expect(tested_instance).to_not receive(:sleep) }

    include_examples :correct_behaviour_with_any_args_and_block, :tested_method_is_protected
  end


  context 'additional checks' do
    subject do
      tested_instance.__send__(tested_method)
    end

    context 'with exception class in arguments' do
      let(:tested_class_namespace) { 'RetryUnsafeSpec' }
      let(:tested_class) { 'WithExceptionArgument' }

      before { expect(tested_instance).to_not receive(:sleep) }

      include_examples :correct_behaviour_of_retry_unsafe_method
    end

    context 'with exception class in arguments and last argument is a hash that contains incorrect wait' do
      let(:tested_class_namespace) { 'RetryUnsafeSpec' }
      let(:tested_class) { 'WithIncorrectWait' }

      before { expect(tested_instance).to_not receive(:sleep) }

      include_examples :correct_behaviour_of_retry_unsafe_method
    end

    context 'with exception class in arguments and last argument is a hash that contains correct wait' do
      let(:tested_class_namespace) { 'RetryUnsafeSpec' }
      let(:tested_class) { 'WithCorrectWait' }

      include_context :stub_expectation_kernel_sleep

      include_examples :correct_behaviour_of_retry_unsafe_method
    end

    context 'when arguments is am array with one hash that contains correct wait' do
      let(:tested_class_namespace) { 'RetryUnsafeSpec' }
      let(:tested_class) { 'WithCorrectWaitAndExceptionBlock' }

      include_context :stub_expectation_kernel_sleep

      include_examples :correct_behaviour_of_retry_unsafe_method
    end

  end


  context 'when trying to retry method that does not exists' do
    subject do

      class WithNotExistingMethod
        include RetryUnsafeMethod::RetryUnsafeMethod

        retry_unsafe_method :qwe, 1, RetryUnsafeSpec::TestError
      end

    end

    it 'raises StandardError with correct message' do
      expect { subject }.to raise_error StandardError, 'method qwe is not defined'
    end

  end

end
module RetryUnsafeSpec
  RETRY_QTY = 3
  SUCCESS_RESULT = :success
  TESTED_METHOD = :qwe

  class TestError < StandardError
  end

  class AnotherError < StandardError
  end

  class Base
    def initialize(qty, error_class)
      @qty = qty
      @error_class = error_class
    end

  end # class Base


  module WithPublic

    class NoArgsNoBlock < RetryUnsafeSpec::Base
      include RetryUnsafeMethod::RetryUnsafeMethod

      def qwe
        if @qty > 0
          @qty -= 1
          raise @error_class.new('rspec')
        else
          [RetryUnsafeSpec::SUCCESS_RESULT]
        end
      end

      retry_unsafe_method :qwe, RetryUnsafeSpec::RETRY_QTY do |e|
        e.is_a?(TestError)
      end
    end

    class WithArgsNoBlock < RetryUnsafeSpec::Base
      include RetryUnsafeMethod::RetryUnsafeMethod

      def qwe(a, b, c)
        if @qty > 0
          @qty -= 1
          raise @error_class.new('rspec')
        else
          [RetryUnsafeSpec::SUCCESS_RESULT, a, b, c]
        end
      end

      retry_unsafe_method :qwe, RetryUnsafeSpec::RETRY_QTY do |e|
        e.is_a?(TestError)
      end
    end

    class NoArgsWithBlock < RetryUnsafeSpec::Base
      include RetryUnsafeMethod::RetryUnsafeMethod

      def qwe
        if @qty > 0
          @qty -= 1
          raise @error_class.new('rspec')
        else
          [RetryUnsafeSpec::SUCCESS_RESULT, yield]
        end
      end

      retry_unsafe_method :qwe, RetryUnsafeSpec::RETRY_QTY do |e|
        e.is_a?(TestError)
      end
    end

    class WithArgsWithBlock < RetryUnsafeSpec::Base
      include RetryUnsafeMethod::RetryUnsafeMethod

      def qwe(a, b, c)
        if @qty > 0
          @qty -= 1
          raise @error_class.new('rspec')
        else
          [RetryUnsafeSpec::SUCCESS_RESULT, a, b, c, yield]
        end
      end

      retry_unsafe_method :qwe, RetryUnsafeSpec::RETRY_QTY do |e|
        e.is_a?(TestError)
      end
    end

  end # module WithPublic


  module WithPrivate

    class NoArgsNoBlock < RetryUnsafeSpec::Base
      include RetryUnsafeMethod::RetryUnsafeMethod

      def qwe
        if @qty > 0
          @qty -= 1
          raise @error_class.new('rspec')
        else
          [RetryUnsafeSpec::SUCCESS_RESULT]
        end
      end

      private :qwe

      retry_unsafe_method :qwe, RetryUnsafeSpec::RETRY_QTY do |e|
        e.is_a?(TestError)
      end
    end

    class WithArgsNoBlock < RetryUnsafeSpec::Base
      include RetryUnsafeMethod::RetryUnsafeMethod

      def qwe(a, b, c)
        if @qty > 0
          @qty -= 1
          raise @error_class.new('rspec')
        else
          [RetryUnsafeSpec::SUCCESS_RESULT, a, b, c]
        end
      end

      private :qwe

      retry_unsafe_method :qwe, RetryUnsafeSpec::RETRY_QTY do |e|
        e.is_a?(TestError)
      end
    end

    class NoArgsWithBlock < RetryUnsafeSpec::Base
      include RetryUnsafeMethod::RetryUnsafeMethod

      def qwe
        if @qty > 0
          @qty -= 1
          raise @error_class.new('rspec')
        else
          [RetryUnsafeSpec::SUCCESS_RESULT, yield]
        end
      end

      private :qwe

      retry_unsafe_method :qwe, RetryUnsafeSpec::RETRY_QTY do |e|
        e.is_a?(TestError)
      end
    end

    class WithArgsWithBlock < RetryUnsafeSpec::Base
      include RetryUnsafeMethod::RetryUnsafeMethod

      def qwe(a, b, c)
        if @qty > 0
          @qty -= 1
          raise @error_class.new('rspec')
        else
          [RetryUnsafeSpec::SUCCESS_RESULT, a, b, c, yield]
        end
      end

      private :qwe

      retry_unsafe_method :qwe, RetryUnsafeSpec::RETRY_QTY do |e|
        e.is_a?(TestError)
      end
    end

  end # module WithPrivate


  module WithProtected

    class NoArgsNoBlock < RetryUnsafeSpec::Base
      include RetryUnsafeMethod::RetryUnsafeMethod

      def qwe
        if @qty > 0
          @qty -= 1
          raise @error_class.new('rspec')
        else
          [RetryUnsafeSpec::SUCCESS_RESULT]
        end
      end

      protected :qwe

      retry_unsafe_method :qwe, RetryUnsafeSpec::RETRY_QTY do |e|
        e.is_a?(TestError)
      end
    end

    class WithArgsNoBlock < RetryUnsafeSpec::Base
      include RetryUnsafeMethod::RetryUnsafeMethod

      def qwe(a, b, c)
        if @qty > 0
          @qty -= 1
          raise @error_class.new('rspec')
        else
          [RetryUnsafeSpec::SUCCESS_RESULT, a, b, c]
        end
      end

      protected :qwe

      retry_unsafe_method :qwe, RetryUnsafeSpec::RETRY_QTY do |e|
        e.is_a?(TestError)
      end
    end

    class NoArgsWithBlock < RetryUnsafeSpec::Base
      include RetryUnsafeMethod::RetryUnsafeMethod

      def qwe
        if @qty > 0
          @qty -= 1
          raise @error_class.new('rspec')
        else
          [RetryUnsafeSpec::SUCCESS_RESULT, yield]
        end
      end

      protected :qwe

      retry_unsafe_method :qwe, RetryUnsafeSpec::RETRY_QTY do |e|
        e.is_a?(TestError)
      end
    end

    class WithArgsWithBlock < RetryUnsafeSpec::Base
      include RetryUnsafeMethod::RetryUnsafeMethod

      def qwe(a, b, c)
        if @qty > 0
          @qty -= 1
          raise @error_class.new('rspec')
        else
          [RetryUnsafeSpec::SUCCESS_RESULT, a, b, c, yield]
        end
      end

      protected :qwe

      retry_unsafe_method :qwe, RetryUnsafeSpec::RETRY_QTY do |e|
        e.is_a?(TestError)
      end
    end

  end # module WithProtected


end

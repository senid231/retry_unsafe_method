module RetryUnsafeMethod

  module RetryUnsafeMethod
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def retry_unsafe_method(method_name, retry_count, *exceptions, &block)
        options = exceptions.last.is_a?(Hash) ? exceptions.pop : {}

        wait = options.delete(:wait)
        wait = nil if wait && (!wait.is_a?(Numeric) || wait <= 0)

        unless method_defined?(method_name) || private_method_defined?(method_name)
          raise StandardError.new("method #{method_name} is not defined")
        end

        if block_given?
          raise StandardError.new('you must not pass exceptions and block simultaneously') if exceptions.size > 0
          check_proc = block
        else
          raise StandardError.new('you must pass exceptions or block') if exceptions.size == 0
          check_proc = Proc.new { |e| exceptions.map(&:to_s).include?(e.class.to_s) }
        end

        safe_method_name = :"#{method_name}_safe_with_retry"
        unsafe_method_name = :"#{method_name}_unsafe_without_retry"

        define_method(safe_method_name) do |*args, &block|
          begin
            __send__(unsafe_method_name, *args, &block)
          rescue StandardError => e
            ivar = :"@current_retry_#{method_name}"
            if check_proc.call(e)
              instance_variable_set(ivar, 0) unless instance_variable_defined?(ivar)

              if instance_variable_get(ivar) < retry_count
                instance_variable_set(ivar, instance_variable_get(ivar) + 1)
                sleep(wait) if wait
                retry
              else
                remove_instance_variable(ivar)
                raise e
              end

            else
              remove_instance_variable(ivar) if instance_variable_defined?(ivar)
              raise e
            end
          end
        end # define_method

        if private_method_defined?(method_name)
          private safe_method_name
        elsif protected_method_defined?(method_name)
          protected safe_method_name
        else
          public safe_method_name
        end

        alias_method unsafe_method_name, method_name
        alias_method method_name, safe_method_name
      end

    end
  end

end

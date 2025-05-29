# frozen_string_literal: true

module LlmHub
  module Common
    # Module to define abstract methods for base classes
    module AbstractMethods
      def self.included(base)
        base.extend(ClassMethods)
      end

      # Provides class-level methods for defining abstract methods
      module ClassMethods
        # Define abstract methods that must be implemented by subclasses
        def abstract_methods(*methods)
          methods.each do |method_name|
            define_method(method_name) do |*_args|
              raise NotImplementedError, "#{self.class}##{method_name} must be implemented"
            end
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

module LlmHub
  module Completion
    module Providers
      # Base class for LLM completion providers
      # @abstract Subclass and override required methods to implement a provider
      class Base
        include LlmHub::Common::AbstractMethods

        attr_reader :api_key

        def initialize(api_key)
          @api_key = api_key
        end

        # Required methods - must be implemented by subclasses
        abstract_methods :url, :headers, :request_body, :extract_answer, :extract_tokens
      end
    end
  end
end

# frozen_string_literal: true

module LlmHub
  module Completion
    module Providers
      # DeepSeek completion provider
      # Inherits from OpenAI provider since DeepSeek uses OpenAI-compatible API
      class Deepseek < OpenAI
        COMPLETIONS_URI = 'https://api.deepseek.com/v1/chat/completions'

        def url
          COMPLETIONS_URI
        end
      end
    end
  end
end

# frozen_string_literal: true

module LlmHub
  module Embedding
    module Providers
      # OpenAI embedding provider
      class OpenAI < Base
        EMBEDDINGS_URI = 'https://api.openai.com/v1/embeddings'

        def url
          EMBEDDINGS_URI
        end

        def headers
          {
            'Content-Type' => 'application/json',
            'Authorization' => "Bearer #{@api_key}"
          }
        end

        def request_body(text, model_name, option_params)
          base_params = {
            model: model_name,
            input: text
          }
          base_params.merge(option_params)
        end

        def extract_embedding(response_body)
          data_array = response_body&.dig('data')
          return nil if data_array.nil? || data_array.empty?

          data_array[0]&.dig('embedding')
        end

        def extract_tokens(response_body)
          usage = response_body&.dig('usage')
          {
            total_tokens: usage&.dig('total_tokens'),
            prompt_tokens: usage&.dig('prompt_tokens')
          }
        end
      end
    end
  end
end

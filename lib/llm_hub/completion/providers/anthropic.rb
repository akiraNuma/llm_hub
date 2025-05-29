# frozen_string_literal: true

module LlmHub
  module Completion
    module Providers
      # Anthropic completion provider
      class Anthropic < Base
        COMPLETIONS_URI = 'https://api.anthropic.com/v1/messages'

        def url
          COMPLETIONS_URI
        end

        def headers
          {
            'Content-Type' => 'application/json',
            'x-api-key' => @api_key,
            'anthropic-version' => '2023-06-01'
          }
        end

        def request_body(system_prompt, content, model_name, option_params)
          base_params = {
            model: model_name,
            max_tokens: 1024,
            temperature: 0.2,
            system: system_prompt,
            messages: [
              { role: 'user', content: content }
            ]
          }
          base_params.merge(option_params)
        end

        def extract_answer(response_body)
          response_body&.dig('content')&.first&.dig('text')
        end

        def extract_tokens(response_body)
          usage = response_body&.dig('usage')
          {
            total_tokens: (usage&.dig('input_tokens') || 0) + (usage&.dig('output_tokens') || 0),
            prompt_tokens: usage&.dig('input_tokens'),
            completion_tokens: usage&.dig('output_tokens')
          }
        end
      end
    end
  end
end

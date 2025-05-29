# frozen_string_literal: true

module LlmHub
  module Completion
    module Providers
      # OpenAI completion provider
      class OpenAI < Base
        COMPLETIONS_URI = 'https://api.openai.com/v1/chat/completions'

        def url
          COMPLETIONS_URI
        end

        def headers
          {
            'Content-Type' => 'application/json',
            'Authorization' => "Bearer #{@api_key}"
          }
        end

        def request_body(system_prompt, content, model_name, option_params)
          base_params = {
            model: model_name,
            n: 1,
            temperature: 0.2,
            messages: build_messages(system_prompt, content)
          }
          base_params.merge(option_params)
        end

        def extract_answer(response_body)
          choices = response_body&.dig('choices')
          return nil if choices.nil? || choices.empty?

          choices[0]&.dig('message', 'content')
        end

        def extract_tokens(response_body)
          usage = response_body&.dig('usage')
          {
            total_tokens: usage&.dig('total_tokens'),
            prompt_tokens: usage&.dig('prompt_tokens'),
            completion_tokens: usage&.dig('completion_tokens')
          }
        end

        private

        def build_messages(system_prompt, content)
          [
            { role: 'system', content: system_prompt },
            { role: 'user', content: content }
          ]
        end
      end
    end
  end
end

# frozen_string_literal: true

module LlmHub
  module Completion
    module Providers
      # Google Gemini completion provider
      class Google < Base
        COMPLETIONS_URI = 'https://generativelanguage.googleapis.com/v1beta/models'

        def url(model_name)
          # Gemini API requires model name in URL
          "#{COMPLETIONS_URI}/#{model_name}:generateContent"
        end

        def headers
          {
            'Content-Type' => 'application/json',
            'x-goog-api-key' => @api_key
          }
        end

        def request_body(system_prompt, content, _model_name, option_params)
          {
            system_instruction: build_system_instruction(system_prompt),
            contents: build_contents(content),
            generationConfig: build_generation_config(option_params)
          }
        end

        def extract_answer(response_body)
          response_body&.dig('candidates', 0, 'content', 'parts', 0, 'text')
        end

        def extract_tokens(response_body)
          usage_metadata = response_body&.dig('usageMetadata')
          {
            total_tokens: usage_metadata&.dig('totalTokenCount'),
            prompt_tokens: usage_metadata&.dig('promptTokenCount'),
            completion_tokens: usage_metadata&.dig('candidatesTokenCount')
          }
        end

        private

        def build_system_instruction(system_prompt)
          {
            parts: [
              {
                text: system_prompt
              }
            ]
          }
        end

        def build_contents(content)
          [{
            role: 'user',
            parts: [{ text: content }]
          }]
        end

        def build_generation_config(option_params)
          base_config = {
            temperature: 0.2,
            maxOutputTokens: 1024,
            topP: 0.8,
            topK: 40
          }

          option_params.any? ? base_config.merge(option_params) : base_config
        end
      end
    end
  end
end

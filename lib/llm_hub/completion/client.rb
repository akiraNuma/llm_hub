# frozen_string_literal: true

module LlmHub
  module Completion
    # Client for LLM providers (OpenAI, Anthropic, etc.)
    class Client < LlmHub::Common::ClientBase
      # Available provider mappings
      # @return [Hash<Symbol, Class>] mapping of provider names to their classes
      PROVIDER_CLASSES = {
        openai: Providers::OpenAI,
        anthropic: Providers::Anthropic,
        deepseek: Providers::Deepseek
      }.freeze

      # Initialize a new completion client
      # @param api_key [String] API key for the provider (required)
      # @param provider [Symbol, String] Provider name (:openai, :anthropic, :deepseek) (required)
      # @param open_time_out [Integer] HTTP open timeout in seconds (optional, defaults to Config value)
      # @param read_time_out [Integer] HTTP read timeout in seconds (optional, defaults to Config value)
      # @param retry_count [Integer] Number of retries for failed requests (optional, defaults to Config value)
      # @see LlmHub::Common::ClientBase#initialize
      def initialize(api_key:, provider:, open_time_out: nil, read_time_out: nil, retry_count: nil)
        super
        @provider_client = create_provider_client
      end

      # Execute a single question prompt and return the response
      # @param system_prompt [String] System prompt for the LLM
      # @param content [String] User content/question
      # @param model_name [String] Model name to use
      # @param option_params [Hash] Additional parameters for the provider
      # @return [Hash{Symbol => String, Integer}] Response with :answer and :tokens keys on success
      #                                            or :error key on failure
      def ask_single_question(
        system_prompt:,
        content:,
        model_name:,
        option_params: {}
      )
        with_retry do
          url = @provider_client.url
          request_body = @provider_client.request_body(system_prompt, content, model_name, option_params)
          headers = @provider_client.headers

          response_body = make_request(url, request_body, headers)
          formatted_response(response_body)
        end
      rescue StandardError => e
        { error: e.message }.deep_symbolize_keys
      end

      private

      # Format the response from provider
      # @param response_body [Hash] Raw response from provider
      # @return [Hash{Symbol => String, Integer}] Formatted response
      def formatted_response(response_body)
        {
          answer: @provider_client.extract_answer(response_body),
          tokens: @provider_client.extract_tokens(response_body)
        }
      end
    end
  end
end

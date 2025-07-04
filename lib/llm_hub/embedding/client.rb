# frozen_string_literal: true

module LlmHub
  module Embedding
    # Client for LLM providers (OpenAI, Anthropic, etc.)
    class Client < LlmHub::Common::ClientBase
      # Available provider mappings
      # @return [Hash<Symbol, Class>] mapping of provider names to their classes
      PROVIDER_CLASSES = {
        openai: Providers::OpenAI
      }.freeze

      # Initialize a new embedding client
      # @param api_key [String] API key for the provider (required)
      # @param provider [Symbol, String] Provider name (:openai) (required)
      # @param open_time_out [Integer] HTTP open timeout in seconds (optional, defaults to Config value)
      # @param read_time_out [Integer] HTTP read timeout in seconds (optional, defaults to Config value)
      # @param retry_count [Integer] Number of retries for failed requests (optional, defaults to Config value)
      # @see LlmHub::Common::ClientBase#initialize
      def initialize(api_key:, provider:, open_time_out: nil, read_time_out: nil, retry_count: nil)
        super
        @provider_client = create_provider_client
      end

      # Generate embeddings for the given text
      # @param text [String] The text to generate embeddings for
      # @param model_name [String] The model to use for embedding generation
      # @param option_params [Hash] Additional parameters to pass to the provider
      # @return [Hash{Symbol => Array<Float>, Hash}] Response with :embedding and :tokens keys on success
      #                                            or :error key on failure
      def post_embedding(
        text:,
        model_name:,
        option_params: {}
      )
        with_retry do
          url = @provider_client.url
          request_body = @provider_client.request_body(text, model_name, option_params)
          headers = @provider_client.headers

          response_body = make_request(url, request_body, headers)
          formatted_response(response_body)
        end
      rescue StandardError => e
        { error: e.message }.deep_symbolize_keys
      end

      private

      # Format the API response into a standardized structure
      # @param response_body [Hash] The raw response from the API
      # @return [Hash{Symbol => Object}] Formatted response with embedding and token information
      # @api private
      def formatted_response(response_body)
        {
          embedding: @provider_client.extract_embedding(response_body),
          tokens: @provider_client.extract_tokens(response_body)
        }
      end
    end
  end
end

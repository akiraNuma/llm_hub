# frozen_string_literal: true

module LlmHub
  module Common
    # Base client class for LLM providers
    # Provides common functionality for API clients including HTTP requests,
    # retry logic, and provider initialization
    class ClientBase
      include LlmHub::Common::HttpHelper

      attr_reader :api_key, :provider, :retry_count, :open_time_out, :read_time_out

      # Initialize a new client
      # @param api_key [String] API key for the provider (required)
      # @param provider [Symbol, String] Provider name (required)
      # @param open_time_out [Integer] HTTP open timeout in seconds (optional, defaults to Config value)
      # @param read_time_out [Integer] HTTP read timeout in seconds (optional, defaults to Config value)
      # @param retry_count [Integer] Number of retries for failed requests (optional, defaults to Config value)
      def initialize(api_key:, provider:, open_time_out: nil, read_time_out: nil, retry_count: nil)
        @api_key = api_key
        @provider = provider
        @open_time_out = open_time_out || LlmHub::Config::DEFAULT_OPEN_TIME_OUT
        @read_time_out = read_time_out || LlmHub::Config::DEFAULT_READ_TIME_OUT
        @retry_count = retry_count || LlmHub::Config::DEFAULT_RETRY_COUNT
      end

      protected

      def create_provider_client
        # Use PROVIDER_CLASSES defined in subclasses
        provider_classes = self.class::PROVIDER_CLASSES
        # Convert to symbol to support both string and symbol
        provider_key = @provider.to_sym
        provider_class = provider_classes[provider_key]

        raise ArgumentError, "Unknown provider: #{@provider}." unless provider_class

        provider_class.new(@api_key)
      end

      def with_retry(&)
        retries = 0
        begin
          yield
        rescue StandardError => e
          retries += 1
          retry if retries < @retry_count
          # Raise the exception if the last retry fails
          raise "Request failed after #{@retry_count} retries: [#{e.class}] #{e.message}"
        end
      end

      def make_request(url, request_body, headers)
        res = http_post(url, request_body, headers)

        unless res.is_a?(Net::HTTPSuccess)
          error_message = begin
            JSON.parse(res.body).to_s
          rescue JSON::ParserError
            res.body.to_s
          end
          raise "HTTP #{res.code} Error: #{error_message}"
        end

        JSON.parse(res.body)
      end
    end
  end
end

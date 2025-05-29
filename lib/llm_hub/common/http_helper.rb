# frozen_string_literal: true

module LlmHub
  module Common
    # Module to provide HTTP helper methods
    module HttpHelper
      # Call API endpoint for Post
      #
      # @param url [String] URL
      # @param request_body [String] Request body
      # @param headers [Hash] Headers
      # @return [Hash] Response
      def http_post(url, request_body, headers = {})
        # generate uri http
        uri = URI.parse(url)
        http = http_client(uri)
        # http request
        http.post(uri.path, request_body.to_json, headers)
      end

      # Return HTTP client based on Uri
      #
      # @param uri [URI::HTTP] Uri
      # @return [Net::HTTP] HTTP
      def http_client(uri)
        http_client = Net::HTTP.new(
          uri.host,
          uri.port
        )
        http_client.use_ssl = uri.scheme == 'https'
        http_client.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http_client.open_timeout = LlmHub::Config::OPEN_TIME_OUT
        http_client.read_timeout = LlmHub::Config::READ_TIME_OUT
        http_client
      end
    end
  end
end

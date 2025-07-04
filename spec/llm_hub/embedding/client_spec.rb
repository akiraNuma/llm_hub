# frozen_string_literal: true

require 'spec_helper'
require 'llm_hub/embedding/client'

RSpec.describe LlmHub::Embedding::Client do
  describe '#initialize' do
    it 'creates OpenAI provider when specified' do
      client = described_class.new(api_key: 'test-key', provider: 'openai')
      expect(client.instance_variable_get(:@provider)).to eq('openai')
    end

    it 'raises error for unsupported provider' do
      expect do
        described_class.new(api_key: 'test-key', provider: 'unsupported')
      end.to raise_error(ArgumentError, 'Unknown provider: unsupported.')
    end

    it 'uses default config values when no custom values provided' do
      client = described_class.new(api_key: 'test-key', provider: 'openai')
      expect(client.open_time_out).to eq(LlmHub::Config::DEFAULT_OPEN_TIME_OUT)
      expect(client.read_time_out).to eq(LlmHub::Config::DEFAULT_READ_TIME_OUT)
      expect(client.retry_count).to eq(LlmHub::Config::DEFAULT_RETRY_COUNT)
    end

    it 'uses custom config values when provided' do
      client = described_class.new(
        api_key: 'test-key',
        provider: 'openai',
        open_time_out: 15,
        read_time_out: 45,
        retry_count: 2
      )
      expect(client.open_time_out).to eq(15)
      expect(client.read_time_out).to eq(45)
      expect(client.retry_count).to eq(2)
    end

    it 'uses mix of default and custom config values' do
      client = described_class.new(
        api_key: 'test-key',
        provider: 'openai',
        retry_count: 5
      )
      expect(client.open_time_out).to eq(LlmHub::Config::DEFAULT_OPEN_TIME_OUT)
      expect(client.read_time_out).to eq(LlmHub::Config::DEFAULT_READ_TIME_OUT)
      expect(client.retry_count).to eq(5)
    end
  end

  describe '#post_embedding' do
    let(:api_key) { 'test-api-key' }
    let(:client) { described_class.new(api_key: api_key, provider: provider) }
    let(:text) { 'This is a test sentence.' }
    let(:model_name) { 'text-embedding-ada-002' }

    context 'with OpenAI provider' do
      let(:provider) { 'openai' }

      it 'sends request to OpenAI API and returns embedding and token usage' do
        # mock
        mock_response = {
          'data' => [
            {
              'embedding' => [0.1, 0.2, 0.3],
              'index' => 0,
              'object' => 'embedding'
            }
          ],
          'model' => model_name,
          'object' => 'list',
          'usage' => {
            'prompt_tokens' => 5,
            'total_tokens' => 5
          }
        }

        allow(client).to receive(:make_request).and_return(mock_response)

        result = client.post_embedding(
          text: text,
          model_name: model_name
        )

        expect(result[:embedding]).to eq([0.1, 0.2, 0.3])
        expect(result[:tokens]).to eq({
                                        prompt_tokens: 5,
                                        total_tokens: 5
                                      })
      end
    end
  end
end

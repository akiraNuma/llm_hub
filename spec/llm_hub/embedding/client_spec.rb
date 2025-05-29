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

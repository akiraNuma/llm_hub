# frozen_string_literal: true

require 'spec_helper'
require 'llm_hub/completion/client'

RSpec.describe LlmHub::Completion::Client do
  describe '#initialize' do
    it 'creates OpenAI provider when specified' do
      client = described_class.new(api_key: 'test-key', provider: 'openai')
      expect(client.instance_variable_get(:@provider)).to eq('openai')
    end

    it 'creates Anthropic provider when specified' do
      client = described_class.new(api_key: 'test-key', provider: 'anthropic')
      expect(client.instance_variable_get(:@provider)).to eq('anthropic')
    end

    it 'creates DeepSeek provider when specified' do
      client = described_class.new(api_key: 'test-key', provider: 'deepseek')
      expect(client.instance_variable_get(:@provider)).to eq('deepseek')
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
        open_time_out: 10,
        read_time_out: 30,
        retry_count: 3
      )
      expect(client.open_time_out).to eq(10)
      expect(client.read_time_out).to eq(30)
      expect(client.retry_count).to eq(3)
    end

    it 'uses mix of default and custom config values' do
      client = described_class.new(
        api_key: 'test-key',
        provider: 'openai',
        open_time_out: 15
      )
      expect(client.open_time_out).to eq(15)
      expect(client.read_time_out).to eq(LlmHub::Config::DEFAULT_READ_TIME_OUT)
      expect(client.retry_count).to eq(LlmHub::Config::DEFAULT_RETRY_COUNT)
    end
  end

  describe '#ask_single_question' do
    let(:api_key) { 'test-api-key' }
    let(:client) { described_class.new(api_key: api_key, provider: provider) }
    let(:system_prompt) { 'You are a helpful assistant.' }
    let(:content) { 'Hello, how are you?' }
    let(:model_name) { 'gpt-4o-mini' }

    context 'with OpenAI provider' do
      let(:provider) { 'openai' }

      it 'sends request to OpenAI API' do
        # mock
        mock_response = {
          'choices' => [
            {
              'message' => {
                'content' => 'I am doing well, thank you!'
              }
            }
          ],
          'usage' => {
            'prompt_tokens' => 10,
            'completion_tokens' => 5,
            'total_tokens' => 15
          }
        }

        allow(client).to receive(:make_request).and_return(mock_response)

        result = client.ask_single_question(
          system_prompt: system_prompt,
          content: content,
          model_name: model_name
        )

        expect(result[:answer]).to eq('I am doing well, thank you!')
        expect(result[:tokens]).to eq({
                                        prompt_tokens: 10,
                                        completion_tokens: 5,
                                        total_tokens: 15
                                      })
      end
    end

    context 'with Anthropic provider' do
      let(:provider) { 'anthropic' }

      it 'sends request to Anthropic API' do
        # mock
        mock_response = {
          'content' => [
            {
              'text' => 'I am Claude, doing well!'
            }
          ],
          'usage' => {
            'input_tokens' => 12,
            'output_tokens' => 6
          }
        }

        allow(client).to receive(:make_request).and_return(mock_response)

        result = client.ask_single_question(
          system_prompt: system_prompt,
          content: content,
          model_name: 'claude-3-opus-20240229'
        )

        expect(result[:answer]).to eq('I am Claude, doing well!')
        expect(result[:tokens]).to eq({
                                        prompt_tokens: 12,
                                        completion_tokens: 6,
                                        total_tokens: 18
                                      })
      end
    end

    context 'with DeepSeek provider' do
      let(:provider) { 'deepseek' }

      it 'sends request to DeepSeek API' do
        # mock
        mock_response = {
          'choices' => [
            {
              'message' => {
                'content' => 'I am DeepSeek, doing great!'
              }
            }
          ],
          'usage' => {
            'prompt_tokens' => 8,
            'completion_tokens' => 7,
            'total_tokens' => 15
          }
        }

        allow(client).to receive(:make_request).and_return(mock_response)

        result = client.ask_single_question(
          system_prompt: system_prompt,
          content: content,
          model_name: 'deepseek-chat'
        )

        expect(result[:answer]).to eq('I am DeepSeek, doing great!')
        expect(result[:tokens]).to eq({
                                        prompt_tokens: 8,
                                        completion_tokens: 7,
                                        total_tokens: 15
                                      })
      end
    end
  end
end

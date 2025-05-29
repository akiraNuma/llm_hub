#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'llm_hub'

# Completion example using OpenAI's GPT-4o-mini model
client = LlmHub::Completion::Client.new(
  api_key: ENV.fetch('OPENAI_API_KEY', nil),
  provider: :openai
)

response = client.ask_single_question(
  system_prompt: 'You are a helpful assistant.',
  content: 'What is the capital of Japan?',
  model_name: 'gpt-4o-mini'
)

# Check for errors and display if any
if response[:error]
  puts "Error occurred: #{response[:error]}"
else
  puts "Answer: #{response[:answer]}"
  puts "Tokens used: #{response[:tokens]}"
end

# Or, use it simply (returns nil on error)
puts response[:answer] if response[:answer]

# Embedding example using OpenAI's text-embedding-3-small model
embedding_client = LlmHub::Embedding::Client.new(
  api_key: ENV.fetch('OPENAI_API_KEY', nil),
  provider: :openai
)

embedding_response = embedding_client.post_embedding(
  text: 'This is a sample text to generate an embedding.',
  model_name: 'text-embedding-3-small'
)

# Check for errors and display if any
if embedding_response[:error]
  puts "Error occurred: #{embedding_response[:error]}"
else
  puts "Embedding: #{embedding_response[:embedding]&.length} dimensions"
  puts "Tokens used: #{embedding_response[:tokens]}"
end

# Or, use it simply (returns nil on error)
puts embedding_response[:embedding]&.length if embedding_response[:embedding]

# LlmHub

This is a Ruby interface for multiple LLM providers, such as OpenAI, Anthropic, and DeepSeek.

It provides easy access to Completion and Embedding functionalities.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add llm_hub
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install llm_hub
```

## Usage

```ruby
client = LlmHub::Completion::Client.new(
  api_key: ENV['OPENAI_API_KEY'],
  provider: :openai
)

response = client.ask_single_question(
  system_prompt: 'You are a helpful assistant.',
  content: 'What is the capital of Japan?',
  model_name: 'gpt-4o-mini'
)

puts response
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/akiraNuma/llm_hub.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

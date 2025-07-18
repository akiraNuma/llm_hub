# frozen_string_literal: true

require_relative 'lib/llm_hub/version'

Gem::Specification.new do |spec|
  spec.name           = 'llm_hub'
  spec.version        = LlmHub::VERSION
  spec.authors        = ['akiraNuma']
  spec.email          = ['akiran@akiranumakura.com']

  spec.summary        = 'A Ruby interface for multiple LLM providers.'
  spec.description    = 'A Ruby interface for multiple LLM providers.' \
                        'It provides easy access to Completion and Embedding functionalities.'
  spec.homepage       = 'https://github.com/akiraNuma/llm_hub'
  spec.license        = 'MIT'
  spec.required_ruby_version = '>= 3.1.0'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/akiraNuma/llm_hub'
  spec.metadata['changelog_uri'] = 'https://github.com/akiraNuma/llm_hub/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'
  spec.add_dependency 'json'

  spec.metadata['rubygems_mfa_required'] = 'true'
end

# frozen_string_literal: true

# Standard libraries
require 'net/http'
require 'json'
require 'openssl'
require 'active_support/core_ext/hash/keys'

require_relative 'llm_hub/version'
require_relative 'llm_hub/config'

# Common modules
require_relative 'llm_hub/common/abstract_methods'
require_relative 'llm_hub/common/http_helper'
require_relative 'llm_hub/common/client_base'

# Completion providers
require_relative 'llm_hub/completion/providers/base'
require_relative 'llm_hub/completion/providers/openai'
require_relative 'llm_hub/completion/providers/anthropic'
require_relative 'llm_hub/completion/providers/deepseek'
require_relative 'llm_hub/completion/providers/google'
require_relative 'llm_hub/completion/client'

# Embedding providers
require_relative 'llm_hub/embedding/providers/base'
require_relative 'llm_hub/embedding/providers/openai'
require_relative 'llm_hub/embedding/client'

module LlmHub
  class Error < StandardError; end
end

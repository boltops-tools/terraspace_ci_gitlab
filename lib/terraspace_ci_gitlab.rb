# frozen_string_literal: true

require "terraspace_ci_gitlab/autoloader"
TerraspaceCiGitlab::Autoloader.setup

require "json"
require "memoist"

module TerraspaceCiGitlab
  class Error < StandardError; end
end

require "terraspace"
Terraspace::Cloud::Ci.register(
  name: "gitlab",
  env_key: "GITLAB_CI", # NOTE: probably have to change. Env var used for CI detection
  root: __dir__,
)

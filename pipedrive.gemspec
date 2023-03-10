# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$:.unshift(lib) unless $:.include?(lib)
require "pipedrive/version"

Gem::Specification.new do |gem|
  gem.name          = "pipedrive"
  gem.version       = Pipedrive::VERSION
  gem.authors       = ["Alexander Simonov"]
  gem.email         = ["alex@amoniac.eu"]
  gem.summary       = "Pipedrive.com API Wrapper"
  gem.description   = "Pipedrive.com API Wrapper"
  gem.homepage      = "https://github.com/amoniacou/pipedrive.rb"
  gem.license       = "MIT"

  gem.files         = %x(git ls-files -z).split("\x0")
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.require_paths = ["lib"]
  gem.required_ruby_version = ">=2.5"

  gem.add_dependency("activesupport", ">= 4.0.0")
  gem.add_dependency("faraday")
  gem.add_dependency("faraday-mashify")
  gem.add_dependency("hashie", ">= 3.0")
  gem.add_development_dependency("bundler")
  gem.add_development_dependency("rake", "> 12")
  gem.add_development_dependency("rspec", ">= 3.0")
  gem.add_development_dependency("rubocop")
  gem.add_development_dependency("rubocop-performance")
  gem.add_development_dependency("rubocop-rspec")
  gem.add_development_dependency("webmock")
  gem.metadata["rubygems_mfa_required"] = "true"
end

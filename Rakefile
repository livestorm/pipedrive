# frozen_string_literal: true

require "bundler/gem_tasks"

begin
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError # rubocop:disable Lint/SuppressedException
end

# rubocop
require "rubocop/rake_task"
RuboCop::RakeTask.new(:rubocop)

default_tasks = [:spec, :rubocop]

task default: default_tasks

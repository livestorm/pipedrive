# frozen_string_literal: true

require "logger"
require "active_support/core_ext/hash"
require "active_support/core_ext/array"
require "active_support/core_ext/numeric/time"
require "active_support/concern"
require "active_support/inflector"

require "hashie"
require "faraday"
require "faraday/mashify"
require_relative "pipedrive/version"

module Pipedrive
  extend self
  attr_accessor :api_token, :debug
  attr_writer :user_agent, :logger

  # ensures the setup only gets run once
  @_ran_once = false

  def reset!
    @logger = nil
    @_ran_once = false
    @user_agent = nil
    @api_token = nil
  end

  def user_agent
    @user_agent ||= "Pipedrive Ruby Client v#{::Pipedrive::VERSION}"
  end

  def setup
    yield self unless @_ran_once
    @_ran_once = true
  end

  def logger
    @logger ||= Logger.new($stdout)
  end

  reset!
end

require_relative "pipedrive/railties" if defined?(::Rails)

# Core
require_relative "pipedrive/base"
require_relative "pipedrive/utils"
require_relative "pipedrive/operations/create"
require_relative "pipedrive/operations/read"
require_relative "pipedrive/operations/update"
require_relative "pipedrive/operations/delete"

# Persons
require_relative "pipedrive/person_field"
require_relative "pipedrive/person"

# Organizations
require_relative "pipedrive/organization_field"
require_relative "pipedrive/organization"

# Filters
require_relative "pipedrive/filter"

# Products
require_relative "pipedrive/product_field"
require_relative "pipedrive/product"

# Roles
require_relative "pipedrive/role"

# Stages
require_relative "pipedrive/stage"

# Goals
require_relative "pipedrive/goal"

# Activities
require_relative "pipedrive/activity"
require_relative "pipedrive/activity_type"

# Deals
require_relative "pipedrive/deal_field"
require_relative "pipedrive/deal"

# Lead
require_relative "pipedrive/lead_label"
require_relative "pipedrive/lead"

# Files
require_relative "pipedrive/file"

# Notes
require_relative "pipedrive/note"

# Users
require_relative "pipedrive/user"

# Pipelines
require_relative "pipedrive/pipeline"

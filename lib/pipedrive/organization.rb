# frozen_string_literal: true

module Pipedrive
  class Organization < Base
    include ::Pipedrive::Operations::Read
    include ::Pipedrive::Operations::Create
    include ::Pipedrive::Operations::Update
    include ::Pipedrive::Operations::Delete
    include ::Pipedrive::Utils

    def find_by_name(*args, &block)
      params = args.extract_options!
      params[:term] ||= args[0]
      raise "term is missing" unless params[:term]

      return to_enum(:find_by_name, params) unless block

      follow_pagination(:make_api_call, [:get, "find"], params, &block)
    end

    def each_deals(id, params = {}, &block)
      return to_enum(:deals, id, params) unless block_given?

      follow_pagination(:deals_chunk, [id], params, &block)
    end

    def deals(id, params = {})
      make_api_call(:get, "#{id}/deals")
    end

    def deals_chunk(id, params = {})
      res = make_api_call(:get, "#{id}/deals")
      return [] unless res.success?

      res
    end
  end
end

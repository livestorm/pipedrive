# frozen_string_literal: true

module Pipedrive
  class Person < Base
    include ::Pipedrive::Operations::Read
    include ::Pipedrive::Operations::Create
    include ::Pipedrive::Operations::Update
    include ::Pipedrive::Operations::Delete
    include ::Pipedrive::Utils

    def find_by_name(*args, &block)
      params = args.extract_options!
      params[:term] ||= args[0]
      raise "term is missing" unless params[:term]

      params[:search_by_email] ||= args[1] ? 1 : 0
      return to_enum(:find_by_name, params) unless block

      follow_pagination(:make_api_call, [:get, "find"], params, &block)
    end

    def each_deals(id, params = {}, &block)
      return to_enum(:deals, id, params) unless block_given?

      follow_pagination(:deals_chunk, [id], params, &block)
    end

    def deals(id, params = {})
      make_api_call(:get, "#{id}/deals", params)
    end

    def deals_chunk(id, params = {})
      res = make_api_call(:get, "#{id}/deals", params)
      return res unless res.success?

      res
    end
  end
end

# frozen_string_literal: true

module Pipedrive
  class Base
    def initialize(api_token = ::Pipedrive.api_token, logger = nil)
      raise "api_token should be set" if api_token.blank?

      @api_token = api_token
      @logger    = logger
    end

    def connection
      self.class.connection.dup
    end

    def make_api_call(*args)
      params = args.extract_options!
      method = args[0]
      raise "method param missing" if method.blank?

      url = build_url(args, params.delete(:fields_to_select))
      params = params.to_json unless method.to_sym == :get
      begin
        res = connection.__send__(method.to_sym, url, params).tap do |response|
          @logger.info(call_api_log(method.to_sym, url, params, response)) if @logger
        end
      rescue Errno::ETIMEDOUT
        retry
      rescue Faraday::ParsingError
        sleep(5)
        retry
      end
      process_response(res)
    end

    def build_url(args, fields_to_select = nil)
      url = +"/v1/#{entity_name}"
      url << "/#{args[1]}" if args[1]
      url << ":(#{fields_to_select.join(",")})" if fields_to_select.is_a?(::Array) && fields_to_select.size.positive?
      url << "?api_token=#{@api_token}"
      url
    end

    def process_response(res)
      if res.success?
        data = if res.body.is_a?(::Hashie::Mash)
          res.body.merge(success: true)
        else
          ::Hashie::Mash.new(response_body(res.body).merge(success: true))
        end
        return data
      end
      failed_response(res)
    end

    def response_body(json)
      JSON.parse(json)
    rescue StandardError
      {}
    end

    def failed_response(res)
      failed_res = res.body.merge(success: false, not_authorized: false,
        failed: false).merge(res.headers)
      case res.status
      when 401
        failed_res[:not_authorized] = true
      when 420
        failed_res[:failed] = true
      end
      failed_res
    end

    def entity_name
      class_name = self.class.name.split("::")[-1].downcase.pluralize
      class_names = { "people" => "persons" }
      class_names[class_name] || class_name
    end

    def call_api_log(http_method, path, opts, response)
      {
        method: "#{self.class.to_s}#make_api_call",
        caller: self.class.to_s,
        content: {
          request: {
            endpoint: {
              http_method: http_method,
              path: path,
              opts: opts,
            },
          },
          response: {
            code: response.status,
            headers: response.headers,
            data: response.body,
          },
        },
      }
    end

    class << self
      def faraday_options
        {
          url: "https://api.pipedrive.com",
          headers: {
            accept: "application/json",
            content_type: "application/json",
            user_agent: ::Pipedrive.user_agent,
          },
        }
      end

      # This method smells of :reek:TooManyStatements
      # :nodoc
      def connection
        @connection ||= Faraday.new(faraday_options) do |conn|
          conn.request(:url_encoded)

          conn.response(:mashify)
          conn.response(:json)
          conn.response(:logger, ::Pipedrive.logger) if ::Pipedrive.debug

          conn.options.timeout = 5.minutes.to_i
          conn.options.open_timeout = 5.minutes.to_i

          conn.adapter(Faraday.default_adapter)
        end
      end
    end
  end
end

require 'faraday'
require_relative 'http_service/request'
require_relative 'http_service/response'

module Blupee
  module HTTPService
    class << self
      # A customized stack of Faraday middleware that will be used to make each request.
      attr_accessor :faraday_middleware
      attr_accessor :http_options
    end

    @http_options ||= {}

    # Blupee's default middleware stack.
    # and use whichever adapter has been configured for this application.
    DEFAULT_MIDDLEWARE = Proc.new do |builder|
      builder.request :url_encoded
      builder.adapter Faraday.default_adapter
    end

    # Makes a request directly to Blupee.
    # @note You'll rarely need to call this method directly.
    #
    #
    # @param request a Blupee::HTTPService::Request object
    #
    # @raise an appropriate connection error if unable to make the request to Blupee
    #
    # @return [Blupee::HTTPService::Response] a response object representing the results from Blupee
    def self.make_request(request)
      # set up our Faraday connection
      conn = Faraday.new(request.server, faraday_options(request.options), &(faraday_middleware || DEFAULT_MIDDLEWARE))
      if request.verb == "post" && request.json?
        # JSON requires a bit more handling
        # remember, all non-GET requests are turned into POSTs, so this covers everything but GETs
        response = conn.post do |req|
          req.path = request.path
          req.headers["Content-Type"] = "application/json"
          req.headers['Bearer'] = Blupee.config.access_token if Blupee.config.access_token
          req.body = request.post_args.to_json
          req
        end
      else
        # response = conn.send(request.verb, request.path, request.post_args)
        response = conn.get do |req|
            req.path = request.path
            req.headers['Bearer'] = Blupee.config.access_token if Blupee.config.access_token
        end
      end

      # Log URL information
      # Blupee::Utils.debug "#{request.verb.upcase}: #{request.path} params: #{request.raw_args.inspect}"
      Blupee::HTTPService::Response.new(response.status.to_i, response.body, response.headers)
    end


    private

    def self.faraday_options(options)
      valid_options = [:request, :proxy, :ssl, :builder, :url, :parallel_manager, :params, :headers, :builder_class]
      Hash[ options.select { |key,value| valid_options.include?(key) } ]
    end
  end
end

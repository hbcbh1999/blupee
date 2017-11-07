module Blupee
  module HTTPService
    class Request
      attr_reader :raw_path, :raw_args, :raw_verb, :raw_options

      # @param path the server path for this request
      # @param args
      # @param verb the HTTP method to use.
      #             If not get or post, this will be turned into a POST request with the appropriate :method
      #             specified in the arguments.
      # @param options various flags to indicate which server to use.
      # @param options
      # @option options :use_ssl force https, even if not needed
      # @option options :json whether or not to send JSON to Blupee
      def initialize(path: path, verb: verb, args: {}, options: {})
        @raw_path = path
        @raw_args = args
        @raw_verb = verb
        @raw_options = options
      end

      # Determines which type of request to send to Blupee. Blupee natively accepts GETs and POSTs, for others we have to include the method in the post body.
      #
      # @return one of get or post
      def verb
        ["get", "post"].include?(raw_verb) ? raw_verb : "post"
      end

      # Determines the path to be requested on Blupee, incorporating an API version if specified.
      #
      # @return the original path, with API version if appropriate.
      def path
        # if an api_version is specified and the path does not already contain
        # one, prepend it to the path
        api_version = raw_options[:api_version] || Blupee.config.api_version
        "/#{api_version}/#{raw_path}"
      end

      # Determines any arguments to be sent in a POST body.
      #
      # @return {} for GET; the provided args for POST; those args with the method parameter for
      # other values
      def post_args
        if raw_verb == "get"
          {}
        elsif raw_verb == "post"
          args
        else
          args.merge(method: raw_verb)
        end
      end

      def get_args
        raw_verb == "get" ? args : {}
      end

      # Calculates a set of request options to pass to Faraday.
      #
      # @return a hash combining GET parameters (if appropriate), default options, and
      # any specified for the request.
      def options
        # figure out our options for this request
        add_ssl_options(
          # for GETs, we pass the params to Faraday to encode
          {params: get_args}.merge(HTTPService.http_options).merge(raw_options)
        )
      end

      # Whether or not this request should use JSON.
      #
      # @return true or false
      def json?
        raw_options[:format] == :json
      end

      # The address of the appropriate Blupee server.
      #
      # @return a complete server address with protocol
      def server
        uri = "#{options[:use_ssl] ? "https" : "http"}://#{Blupee.config.api_server}"
      end

      protected

      # The arguments to include in the request.
      def args
        raw_args
      end

      def add_ssl_options(opts)
        # require https if there's a token
        return opts unless raw_args["access_token"]

        {
          use_ssl: true,
          ssl: {verify: true}.merge(opts[:ssl] || {})
        }.merge(opts)
      end
    end
  end
end

# OpenSSL and Base64 are required to support signed_request
require 'openssl'
require 'base64'

module Blupee
  module API
    class Auth
      attr_reader :client_id, :client_secret

      # Creates a new client.
      #
      # @param client_id [String, Integer] a Blupee client ID
      # @param client_secret a Blupee client secret
      def initialize(client_id = nil, client_secret = nil)
        @client_id = client_id || Blupee.config.client_id
        @client_secret = client_secret || Blupee.config.client_secret
      end

      # access tokens

      # Fetches an access token, token expiration, and other info from Blupee.
      # Useful when you've received an OAuth code using the server-side authentication process.
      # @see url_for_oauth_code
      #
      # @note (see #url_for_oauth_code)
      #
      # @param code (see #url_for_access_token)
      # @param options any additional parameters to send to Blupee when redeeming the token
      #
      # @raise Blupee::OAuthTokenRequestError if Blupee returns an error response
      #
      # @return a hash of the access token info returned by Blupee (token, expiration, etc.)
      def get_access_token_info(options = {})
        # convenience method to get a the application's sessionless access token
         get_token_from_server({}, true, options)
      end

      # Fetches the application's access token (ignoring expiration and other info).
      # @see get_app_access_token_info
      #
      # @param (see #get_app_access_token_info)
      #
      # @return the application access token
      def get_access_token(options = {})
        if info = get_access_token_info(options)
          Blupee.config.access_token = info["access_token"]
        end
      end

      protected

      def get_token_from_server(args, post = false, options = {})
        # fetch the result from Blupee's servers
        response = fetch_token_string(args, post, "auth", options)
        parse_access_token(response)
      end

      def parse_access_token(response_text)
        JSON.parse(response_text)
      rescue JSON::ParserError
        response_text.split("&").inject({}) do |hash, bit|
          key, value = bit.split("=")
          hash.merge!(key => value)
        end
      end


      def fetch_token_string(args, post = false, endpoint = "auth", options = {})
        raise ClientError if @client_id == nil
        raise ClientError if @client_secret == nil
        response = Blupee.make_request("/#{endpoint}", {
          :client_id => @client_id,
          :client_secret => @client_secret
        }.merge!(args), post ? "post" : "get", {:use_ssl => true, format: :json}.merge!(options))

        raise ServerError.new(response.status, response.body) if response.status >= 500
        raise OAuthTokenRequestError.new(response.status, response.body) if response.status >= 400

        response.body
      end

    end
  end
end

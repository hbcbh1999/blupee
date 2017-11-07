require 'faraday'
require 'json'

module Blupee
  module API
    class Ether
      attr_reader :coin_symbol, :balance, :wallet, :transaction_hash

      def initialize(attributes)
        @coin_symbol = attributes["coin_symbol"]
        @balance = attributes["balance"]
        @wallet_address = attributes["wallet_address"]
      end

       # {:wallet_address=>""}
      def self.balance(args, options = {})
        wallet_address = args[:wallet_address]
        response = Blupee.make_request("/eth/#{wallet_address}", {}, "get", {:use_ssl => true}.merge!(options))
        raise ServerError.new(response.status, response.body) if response.status >= 500
        raise OAuthTokenRequestError.new(response.status, response.body) if response.status >= 400
        response
      end


      def self.new_wallet(args, options = {})
        response = Blupee.make_request("/eth/new",
                                       {}.merge!(args),
                                       "post",
                                       {:use_ssl => true,
                                        format: :json}.merge!(options))
        raise ServerError.new(response.status, response.body) if response.status >= 500
        raise OAuthTokenRequestError.new(response.status, response.body) if response.status >= 400
        response
      end

      # {:to_address=>"", :from_address=>"", :password=>"", :quantity=>0.001}
      def self.transfer(args, options = {})
        response = Blupee.make_request("/eth/send", 
                                       {}.merge!(args),
                                       "post",
                                       {:use_ssl => true,
                                        format: :json}.merge!(options))

        raise ServerError.new(response.status, response.body) if response.status >= 500
        raise OAuthTokenRequestError.new(response.status, response.body) if response.status >= 400
        response
      end

    end
  end
end

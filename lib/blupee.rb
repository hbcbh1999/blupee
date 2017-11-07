require_relative "blupee/version"
require_relative 'blupee/errors'
require_relative "blupee/configuration"
require_relative "blupee/http_service"
require_relative "blupee/http_service/request"
require_relative "blupee/http_service/response"
require_relative "blupee/api/auth"
require_relative "blupee/api/ether"
require_relative "blupee/api/omise_go"
require_relative "blupee/api/token"

module Blupee

	class << self
		def configure
		  yield config
		end

		# See Blupee::Configuration.
		def config
		  @config ||= Configuration.new
		end
  end

 	def self.make_request(path, args, verb, options = {})
    HTTPService.make_request(HTTPService::Request.new(path: path, args: args, verb: verb, options: options))
  end
end

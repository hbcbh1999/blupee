# Global configuration for Blupee.
class Blupee::Configuration
  # The default access token to be used if none is otherwise supplied.
  attr_accessor :access_token

  # The default client secret value to be used if none is otherwise supplied.
  attr_accessor :client_secret

  # The default client ID to use if none is otherwise supplied.
  attr_accessor :client_id

  attr_accessor :api_server

  attr_accessor :api_version

  def initialize
    self.api_server = "api.blupee.io"
  	self.api_version = "v1"
  end
end

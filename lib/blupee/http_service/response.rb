module Blupee
  module HTTPService
    class Response
      attr_reader :status, :body, :headers

      # Creates a new Response object, which standardizes the response received by Blupee API for use within Blupee.
      def initialize(status, body, headers)
        @status = status
        @body = body
        @headers = headers
      end

      def data
        # quirks_mode is needed because Blupee sometimes returns a raw true or false value --
        # in Ruby 2.4 we can drop that.
        @data ||= JSON.parse(body, quirks_mode: true) unless body.empty?
      end
    end
  end
end

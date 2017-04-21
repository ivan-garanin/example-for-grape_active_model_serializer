module Nsi
  module Helpers
    module Errors
      def error_403!(options = {})
        content = {
          status: 'Error',
          code: 403,
          message: 'Access denied'
        }
        content.merge!(options)
        error!(content, 403)
      end

      def error_401!(options = {})
        content = {
          status: 'Error',
          code: 401,
          message: 'Unauthorized'
        }
        content.merge!(options)
        error!(content, 401)
      end

      def error_500!(options = {})
        content = {
          status: 'Error',
          code: 500,
          message: 'Internal Server Error'
        }
        content.merge!(options)
        error!(content, 500)
      end

      def error_400!(options = {})
        content = {
          status: 'Error',
          code: 400,
          message: 'Bad request'
        }
        content.merge!(options)
        error!(content, 400)
      end

      def error_422!(options = {})
        error!(options, 422)
      end

      def success!(options = {})
        options.reverse_merge!(status: 'Ok',
                               code: 200)
        Rack::Response.new(options, 200).finish
      end

      def added!(options = {})
        options.reverse_merge!(status: 'Ok',
                               code: 201)

        Rack::Response.new(options, 201, 'Content-type' => 'application/json').finish
      end
    end
  end
end

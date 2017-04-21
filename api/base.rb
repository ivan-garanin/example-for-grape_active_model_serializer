module Nsi
  class Base < Grape::API
    do_not_route_options!

    def self.inherited(subclass)
      super

      subclass.instance_eval do
        before do
          header 'Content-Type', 'application/json; charset=utf-8'
        end

        helpers Nsi::Helpers::Errors

        helpers do

          def logger
            API.logger
          end

          def search_params
            params.fetch(:q, {})
          end
        end

        def server_error_rescuable_classes
          []
        end

        rescue_from Sequel::NoMatchingRow do |e|
          content = { status: 404, status_code: 'not_found' }
          content.merge!(exception: { message: e.message, backtrace: e.backtrace }) unless ENV['RACK_ENV'] == 'production'

          Rack::Response.new(
            [content.to_json],
            404,
            'Content-Type' => 'application/json'
          )
        end

        rescue_from Sequel::ValidationFailed do |e|
          content = { status: 422, status_code: 'record_invalid' }
          content.merge!(exception: { message: e.message, backtrace: e.backtrace }) unless ENV['RACK_ENV'] == 'production'

          Rack::Response.new(
            [content.to_json],
            422,
            'Content-Type' => 'application/json'
          )
        end

        rescue_from *server_error_rescuable_classes do |e|
          content = { status: 500, status_code: 'server_error' }
          content.merge!(exception: { message: e.message, backtrace: e.backtrace }) unless ENV['RACK_ENV'] == 'production'

          Rack::Response.new(
            [content.to_json],
            500,
            'Content-Type' => 'application/json'
          )
        end

      end
    end
  end
end

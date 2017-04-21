module Nsi
  class ParameterResource < Nsi::Base
    helpers do

      def resource_parameter
        @resource_item ||= if params[:id].present?
          ::Parameter.with_pk!(params[:id])
        else
          ::Parameter.new(params[:parameter])
        end
      end

      def parameters_collection
        @parameters_collection ||= if params[:page].present?
          ParameterSearch.new(search_params).results.paginate(params[:page], params[:per] ? params[:per] : 50)
        else
          ParameterSearch.new(search_params).results
        end
      end
    end

    namespace :parameters do
      # GET parameters
      desc 'List of parameters ', {
        http_codes: [
          [200, 'Ok']
        ]
      }

      params do
        optional :per, type: Integer, desc: 'Records count on a page'
        optional :page, type: Integer, default: 1, desc: 'Page number'
        optional :q, type: Hash do
          optional :name_like, type: String, desc: 'Name includes …'
        end
      end

      get '/' do
        parameters_collection
      end

      # GET parameter
      desc 'Get one parameter ', {
        http_codes: [
          [200, 'Ok']
        ]
      }

      params do
        requires :id, type: Integer, desc: 'Record id'
      end

      get ':id' do
        resource_parameter
      end

      # POST parameter
      desc 'Create parameter',{
        http_codes: [
          [201, 'Ok']
        ]
      }

      params do
        requires :parameter, type: Hash do
          requires :name, type: String, desc: 'parameter title'
        end
      end

      post '' do
        if resource_parameter.save
          resource_parameter
        else
          error_400!(message: resource_parameter.errors.full_messages.first.to_s)
        end
      end

      # PATCH parameter
      desc 'Update parameter',{
        http_codes: [
          [200, 'Ok']
        ]
      }

      params do
        requires :id, type: Integer, desc: 'parameter ID'
        requires :parameter, type: Hash do
          optional :name, type: String, desc: 'parameter title'
        end
      end

      patch ':id' do
        if resource_parameter.update(params.fetch(:parameter, {}))
          resource_parameter
        else
          error_400!(message: resource_parameter.errors.full_messages.first.to_s)
        end
      end

      # DELETE parameter
      desc 'Delete parameter',{
        http_codes: [
          [200, 'Ok']
        ]
      }

      params do
        requires :id, type: Integer, desc: 'parameter ID'
      end

      delete ':id' do
        resource_parameter.destroy
        resource_parameter
      end
    end
  end
end
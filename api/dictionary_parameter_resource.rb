module Nsi
  class DictionaryParameterResource < Nsi::Base
    helpers do

      def resource_dictionary_parameter
        @resource_dictionary_parameter ||= if params[:id].present?
          ::DictionaryParameter.with_pk!(params[:id])
        else
          ::DictionaryParameter.new(params[:dictionary_parameter])
        end
      end

      def dictionary_parameters_collection
        @dictionary_parameters_collection ||= if params[:page].present?
          DictionaryParameterSearch.new(search_params).results.paginate(params[:page], params[:per] ? params[:per] : 50)
        elsif params[:per].present?
          DictionaryParameterSearch.new(search_params).results.paginate(1, params[:per])
        else
          DictionaryParameterSearch.new(search_params).results
        end
      end
    end

    namespace :dictionary_parameters do
      # GET dictionary_parameters
      desc 'List of dictionary_parameters ', {
        http_codes: [
          [200, 'Ok']
        ]
      }

      params do
        optional :per, type: Integer, desc: 'Records count on a page'
        optional :page, type: Integer, default: 1, desc: 'Page number'
        optional :q, type: Hash do
          optional :dictionary_name_like, type: String, desc: 'Dictionary Name includes …'
          optional :parameter_name_like, type: String, desc: 'Dictionary Name includes …'
          optional :dictionary_id_eq, type: Integer, desc: 'Dictionary ID'
          optional :parameter_id_eq, type: Integer, desc: 'Parameter ID'
          optional :value_eq, type: String, desc: 'Value'
          # optional :type_eq, type: String, desc: 'Type'
        end
      end

      get '/' do
        # dictionary_parameters_collection
      end

      # GET DictionaryParameter
      desc 'GET dictionary_parameter ', {
        http_codes: [
          [200, 'Ok']
        ]
      }

      params do
        requires :id, type: Integer, desc: 'Record ID'
      end

      get ':id' do
        resource_dictionary_parameter
      end

      # POST DictionaryParameter
      desc 'Create DictionaryParameter',{
        http_codes: [
          [201, 'Ok']
        ]
      }

      params do
        requires :dictionary_parameter, type: Hash do
          requires :dictionary_id, type: Integer, desc: 'Dictionary ID'
          requires :parameter_id, type: Integer, desc: 'Parameter ID'
          requires :value, type: String, desc: 'Value'
          # requires :type, type: String, desc: 'Type'
        end
      end

      post '' do
        if resource_dictionary_parameter.save
          resource_dictionary_parameter
        else
          error_400!(message: resource_dictionary_parameter.errors.full_messages.first.to_s)
        end
      end

      # PATCH DictionaryParameter
      desc 'Update DictionaryParameter',{
        http_codes: [
          [200, 'Ok']
        ]
      }

      params do
        requires :id, type: Integer, desc: 'DictionaryParameter ID'
        requires :dictionary_parameter, type: Hash do
          optional :dictionary_id, type: Integer, desc: 'Dictionary ID'
          optional :parameter_id, type: Integer, desc: 'Parameter ID'
          optional :value, type: String, desc: 'Value'
          # optional :type, type: String, desc: 'Type'
        end
      end

      patch ':id' do
        if resource_dictionary_parameter.update(params.fetch(:dictionary_parameter, {}))
          resource_dictionary_parameter
        else
          error_400!(message: resource_dictionary_parameter.errors.any? ? resource_dictionary_parameter.errors.full_messages.first.to_s : 'Уже обновленно')
        end
      end

      # DELETE DictionaryParameter
      desc 'Delete DictionaryParameter',{
        http_codes: [
          [200, 'Ok']
        ]
      }

      params do
        requires :id, type: Integer, desc: 'DictionaryParameter ID'
      end

      delete ':id' do
        resource_dictionary_parameter.destroy
        resource_dictionary_parameter
      end
    end
  end
end
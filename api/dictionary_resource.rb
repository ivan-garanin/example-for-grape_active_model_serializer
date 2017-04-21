module Nsi
  class DictionaryResource < Nsi::Base
    helpers do

      def resource_dictionary
        @resource_dictionary ||= if params[:id].present?
          ::Dictionary.with_pk!(params[:id])
        else
          ::Dictionary.new(params[:dictionary])
        end
      end

      def dictionaries_collection
        @dictionaries_collection ||= if params[:page].present?
          DictionarySearch.new(search_params).results.paginate(params[:page], params[:per] ? params[:per] : 50)
        else
          DictionarySearch.new(search_params).results
        end
      end
    end

    namespace :dictionaries do
      # GET dictionaries
      desc 'List of dictionaries ', {
        http_codes: [
          [200, 'Ok']
        ]
      }

      params do
        optional :per, type: Integer, desc: 'Records count on a page'
        optional :page, type: Integer, default: 1, desc: 'Page number'
        optional :q, type: Hash do
          optional :name_like, type: String, desc: 'Name includes …'
          optional :ancestor_id, type: Integer, desc: 'Parent id'
        end
      end

      get '/' do
        dictionaries_collection
      end

      # GET dictionary
      desc 'GET dictionary ', {
        http_codes: [
          [200, 'Ok']
        ]
      }

      params do
        requires :id, type: Integer, desc: 'Record id'
      end

      get ':id' do
        resource_dictionary
      end

      # POST dictionary
      desc 'Create Dictionary',{
        http_codes: [
          [201, 'Ok']
        ]
      }

      params do
        requires :dictionary, type: Hash do
          requires :name, type: String, desc: 'Dictionary title'
          optional :ancestor_id, type: Integer, desc: 'Parent dictionary id'
        end
      end

      post '' do
        if resource_dictionary.save
          resource_dictionary
        else
          error_400!(message: resource_dictionary.errors.full_messages.first.to_s)
        end
      end

      # PATCH dictionary
      desc 'Update Dictionary',{
        http_codes: [
          [200, 'Ok']
        ]
      }

      params do
        requires :id, type: Integer, desc: 'Dictionary ID'
        requires :dictionary, type: Hash do
          optional :name, type: String, desc: 'Dictionary title'
          optional :ancestor_id, type: String, desc: 'Parent dictionary id'
        end
      end

      patch ':id' do
        if resource_dictionary.update(params.fetch(:dictionary, {}))
          resource_dictionary
        else
          error_400!(message: resource_dictionary.errors.full_messages.first.to_s)
        end
      end

      # DELETE Dictionary
      desc 'Delete Dictionary',{
        http_codes: [
          [200, 'Ok']
        ]
      }

      params do
        requires :id, type: Integer, desc: 'Dictionary ID'
      end

      delete ':id' do
        resource_dictionary.destroy
        resource_dictionary
      end
    end
  end
end
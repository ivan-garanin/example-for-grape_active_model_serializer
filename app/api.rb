module Nsi
  class API < Grape::API
    format :json
    formatter :json, Grape::Formatter::ActiveModelSerializers

    mount Nsi::DictionaryResource

    add_swagger_documentation :format => :json,
                              :hide_documentation_path => true,
                              :mount_path => 'swagger_doc'

  end
end

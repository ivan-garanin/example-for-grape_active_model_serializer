class DictionarySerializer < ActiveModel::Serializer
  attributes :id, :name, :parent_id

  def parent_id
    object.ancestor_id
  end
end
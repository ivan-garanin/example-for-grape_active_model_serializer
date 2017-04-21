class DictionarySearch < Searchlight::Search
  def base_query
    Dictionary.dataset.eager(:ancestors)
  end

  def search_name_like
    query.where(Sequel.like(:name, "%#{name_like}%"))
  end

  def search_ancestor_id
    query.where(ancestor_id: ancestor_id)
  end
end
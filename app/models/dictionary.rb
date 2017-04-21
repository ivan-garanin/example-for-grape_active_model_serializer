class Dictionary < Sequel::Model
  include ActiveModel::Serialization

  plugin :rcte_tree, key: :ancestor_id
  raise_on_save_failure = false

  def validate
    super
    errors.add(:name, 'cannot be empty') if !name
  end
end
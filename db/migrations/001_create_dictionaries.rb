Sequel.migration do
  up do
    create_table(:dictionaries) do
      primary_key :id
      String :name, null: false
      Integer :ancestor_id, index: true
    end
  end

  down do
    drop_table(:dictionaries)
  end
end
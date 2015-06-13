Sequel.migration do
  change do
    create_table(:urls) do
      primary_key :id
      String :name, null: false
      String :uuid, null: false
      Bignum :redirects, null: false, default: 0

      Time :created_at, null: false

      index [:uuid], unique: true
    end
  end
end

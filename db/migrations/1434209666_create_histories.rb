Sequel.migration do
  change do
    create_table(:histories) do
      primary_key :id
      Integer :url_id, null: false
      String :source_ip, null: false
      Bignum :redirects, null: false, default: 0

      Time :created_at, null: false
    end
  end
end

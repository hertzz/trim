module Trim
  module Models
    class History < Sequel::Model
      dataset_module do
      end

      one_to_one :url

      def validate
        validates_presence [:url_id, :source_ip]
        set_created_at
      end

      def increment_redirects
        self.redirects += 1
        self.save
      end

      private

        def set_created_at
          self.created_at ||= Time.now
        end

    end
  end
end

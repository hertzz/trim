require 'securerandom'

module Trim
  module Models
    class Url < Sequel::Model
      dataset_module do
      end

      one_to_one :history

      def after_save
        super
      end

      def validate
        set_uuid

        validates_url :name
        validates_unique :uuid
        validates_presence [:name, :uuid]

        set_created_at
      end

      def increment_redirects
        self.redirects += 1
        self.save
      end

      private

        def set_uuid
          if self.uuid.nil?
            self.uuid = SecureRandom.hex(6)
          end
        end

        def set_created_at
          self.created_at ||= Time.now
        end
    end
  end
end

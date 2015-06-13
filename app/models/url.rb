require 'securerandom'

module Trim
  module Models
    class Url < Sequel::Model
      dataset_module do
      end

      def validate
        validates_url :name
        validates_unique :uuid
        validates_presence [:name, :uuid]

        set_uuid
        set_created_at
      end

      private

        def set_uuid
          self.uuid = SecureRandom.base64
        end

        def set_created_at
          self.created_at ||= Time.current
        end

    end
  end
end

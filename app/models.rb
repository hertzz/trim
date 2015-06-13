require 'lib/sequel/url_validation_helpers'

Sequel.default_timezone = :utc
Sequel::Model.plugin :validation_helpers
Sequel::Model.plugin Sequel::Plugins::URLValidationHelpers

module Trim
  module Models
    autoload :Url, 'app/models/url'
    autoload :History, 'app/models/history'
  end
end

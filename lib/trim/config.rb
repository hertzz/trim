module Trim
  class Config
    @@data = {}

    def initialize
      ruby_env = ENV['RUBY_ENV'] ||= 'development'
      @@data = YAML.load(ERB.new(File.read('config/application.yml')).result)[ruby_env]
    end

    def get_data
      @@data
    end
  end
end

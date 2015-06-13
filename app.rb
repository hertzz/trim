require 'rubygems'
require 'bundler'
require 'yaml'

Bundler.require

$: << File.expand_path('../', __FILE__)
$: << File.expand_path('../lib', __FILE__)

require 'sinatra/base'
require 'sinatra/sequel'
require 'sinatra/static_cache'
#require 'rack/csrf'
require 'app/models'
require 'app/helpers'
require 'app/routes'

module Trim
  class App < Sinatra::Application
    configure do
      ruby_env = ENV['RUBY_ENV'] ||= 'development'
      db = YAML.load(ERB.new(File.read('config/database.yml')).result)[ruby_env]

      set :database, lambda {
        ENV['DATABASE_URL'] ||
        "mysql2://#{db['username']}:#{db['password']}@#{db['host']}:#{db['port']}/#{db['database']}"
      }
    end

    configure do
      disable :method_override
      disable :static

      enable :logging, :dump_errors, :raise_errors

      set :protection, except: :session_hijacking
      set :erb, escape_html: true
      set :show_exceptions, true

      set :sessions,
          :httponly     => true,
          :secure       => false,
          :expire_after => 31557600, # 1 year
          :secret       => ENV['SESSION_SECRET'] ||= "8971234897123897123897"
    end

    use Rack::Deflater
    #use Rack::Csrf

    #use Trim::Helpers::Global
    use Trim::Routes::Urls
  end
end

include Trim::Models

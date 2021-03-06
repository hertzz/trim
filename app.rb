require 'rubygems'
require 'bundler'
require 'yaml'

Bundler.require

$: << File.expand_path('../', __FILE__)
$: << File.expand_path('../lib', __FILE__)

require 'active_support/inflector'
require 'sinatra/base'
require 'sinatra/sequel'
require 'sinatra/static_cache'
require 'sinatra/flash'
require 'will_paginate'
require 'will_paginate/sequel'
require 'will_paginate/view_helpers/sinatra'
require 'stylus/sprockets'
#require 'rack/csrf'
require 'trim/config'
require 'app/models'
require 'app/helpers'
require 'app/extensions'
require 'app/routes'

module Trim
  class App < Sinatra::Application
    configure do
      ruby_env = ENV['RUBY_ENV'] ||= 'development'
      db = YAML.load(ERB.new(File.read('config/database.yml')).result)[ruby_env]

      set :database, lambda {
        ENV['DATABASE_URL'] ||
        "#{db['adapter']}://#{db['username']}:#{db['password']}@#{db['host']}:#{db['port']}/#{db['database']}"
      }

      set :config, Trim::Config.new.get_data
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
    use Trim::Routes::Root
    use Trim::Routes::Urls
  end
end

include Trim::Models

module Trim
  module Routes
    class Root < Trim::Routes::Base
      get '/' do
        redirect '/urls'
      end

      get '/assets/*' do
        env['PATH_INFO'].sub!(%r{^/assets}, '')
        settings.assets.call(env)
      end

      get '/mobile/*' do
        env['PATH_INFO'].sub!(%r{^/mobile}, '')
        settings.mobile.call(env)
      end
    end
  end
end

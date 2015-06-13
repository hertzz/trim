module Trim
  module Routes
    class Urls < Trim::Routes::Base
      get '/urls' do
        @urls = Url.first
        render_erb :'url/index'
      end

      get '/urls/:uuid' do
        url = Url.first!(uuid: params[:uuid])
        json url
      end

      post '/urls/new' do
        url = Url.create(name: params['name'])
        json url
      end
    end
  end
end

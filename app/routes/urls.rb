module Trim
  module Routes
    class Urls < Trim::Routes::Base
      get '/urls' do
        @urls = Url.all
        render_erb :'url/index'
      end

      get '/urls/go/:uuid' do
        url = Url.first!(uuid: params[:uuid])
        url.increment_redirects
        
        redirect url.name
      end

      get '/urls/new' do
        render_erb :'url/new'
      end

      get '/urls/show/:uuid' do
        begin
          @url = Url.first!(uuid: params[:uuid])
          render_erb :'url/show'
        rescue Exception => e
          flash[:errors] = "Could not find any URL matching the provided key (#{params[:uuid]})"
          redirect '/urls'
        end
      end

      post '/urls/create' do
        begin
          url = Url.create(name: params['name'])
          redirect "/urls/show/#{url.uuid}"
        rescue Exception => e
          flash[:errors] = e.message.capitalize
          redirect '/urls/new'
        end
      end
    end
  end
end

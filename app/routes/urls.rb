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

        # History stuff
        begin
          if history = History.first!(source_ip: request.ip, url_id: url.id)
            history.increment_redirects
          end
        rescue Sequel::NoMatchingRow => e
          record = History.create(
            url_id: url.id,
            source_ip: request.ip
          )

          record.increment_redirects
        end

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
          create_history_record(url)

          flash[:notice] = 'Your shortened URL has been created!'
          redirect "/urls/show/#{url.uuid}"
        rescue Exception => e
          flash[:errors] = e.message.capitalize
          redirect '/urls/new'
        end
      end

      private

      def create_history_record(url)
        begin
          History.create(
            url_id: url.id,
            source_ip: request.ip
          )
        rescue Exception => e
          raise "Failed to create history reference for URL ID \"#{url.uuid}\" (#{e.message})"
        end
      end

    end
  end
end

module Trim
  module Routes
    class Base < Sinatra::Application
      configure do
        set :views, 'app/views'
        set :layouts, 'app/views/layouts'
        set :root, App.root

        # Override default .erb extension
        # Sinatra will fall back to .erb over .html.erb if necessary
        Tilt.register(Tilt::ERBTemplate, 'html.erb')

        enable :use_code

        disable :method_override
        disable :protection
        disable :static

        set :erb, escape_html: true
        set :show_exceptions, :after_handler
      end

      error Sequel::ValidationFailed do
        status 406
        json error: {
          type: 'validation_failed',
          messages: env['sinatra.error'].errors
        }
      end

      #error Sequel::NoMatchingRow do
      #  status 404
      #  json error: {type: 'unknown_record'}
      #end

      helpers do
        def render_erb(view)
          erb view, layout: :'layouts/app'
        end
      end
    end
  end
end

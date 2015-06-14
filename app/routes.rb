require 'will_paginate/view_helpers/sinatra'

module Trim
  module Routes
    autoload :Base, 'app/routes/base'
    autoload :Root, 'app/routes/root'
    autoload :Urls, 'app/routes/urls'
  end
end

require_relative '../spec_helper'

describe 'Trim::Routes::Root' do
  include Rack::Test::Methods

  def app
    Trim::App
  end

  it 'should redirect to the url router from the root context' do
    get '/'
    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_request.url).to match '/urls'
    expect(last_response).to be_ok
  end

  it 'should serve the minified bootstrap stylesheet' do
    get '/assets/bootstrap.min.css'
    expect(last_response).to be_ok
    expect(last_response.body).to match 'Bootstrap'
  end

  it 'should serve the minified bootstrap javascripts' do
    get '/assets/bootstrap.min.js'
    expect(last_response).to be_ok
    expect(last_response.body).to match 'Bootstrap'
  end
end

require_relative '../spec_helper'

describe 'Trim::Routes::Url' do
  include Rack::Test::Methods

  def app
    Trim::App
  end

  it 'should display the home page' do
    get '/urls'
    expect(last_response).to be_ok
  end

  it 'should display the url creation page' do
    get '/urls/new'
    expect(last_response).to be_ok
  end

  it 'should throw an error when trying to create a new url with a malformed url' do
    post '/urls/create?name=domain.com'
    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_response.body).to match "Name is an invalid url"
    expect(last_request.url).to match '/urls/new'
  end

  it 'should throw an error when trying to create a new url with no name specified' do
    post '/urls/create?name='
    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_response.body).to match "Name is an invalid url, name is not present"
    expect(last_request.url).to match '/urls/new'
  end

  it 'should throw an error when trying to view details for an invalid url uuid' do
    get '/urls/show/abc123test'
    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_response.body).to match "Couldn't find a URL for the specified UUID \"abc123test\""
    expect(last_request.url).to match '/urls'
  end

  it 'should display the url statistics page' do
    get '/urls/statistics'
    expect(last_response).to be_ok
  end

  it 'should throw an error when trying to redirect to an invalid url uuid' do
    get '/urls/go/abc123test'
    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_response.body).to match "Couldn't find a URL for the specified UUID \"abc123test\""
    expect(last_request.url).to match '/urls'
  end

  it 'should create a new url redirect for http://www.google.com' do
    post '/urls/create?name=http://www.google.com'
    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_response.body).to match "Your shortened URL has been created!"
    expect(last_request.url).to match '/urls/show/*'
  end
end

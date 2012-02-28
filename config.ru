require 'omniauth'
require 'omniauth-google-oauth2'

use Rack::Session::Cookie, :secret => ENV['GRAPHITI_SESSION_SECRET']

require './graphiti'

class Graphiti < Sinatra::Base
  def authenticated?
    !session['authorized'].nil? and session['authorized']
  end

  before /^(?!\/(auth))/ do
    redirect '/auth/google_oauth2' unless authenticated?
  end

  get '/auth/google_oauth2/callback' do
    puts "New auth: #{request.env['omniauth.auth']}"
    begin
      session['authorized'] = true if request.env['omniauth.auth']['info']['email'].end_with?("otherinbox.com")
      redirect '/'
    rescue
      session['authorized'] = false
      redirect '/auth/failure'
    end
  end

  get '/auth/failure' do
    content_type 'text/plain'
    "Authentication failed.  Click <a href='/auth/google_oauth2'>here</a> to try again, and make sure to use your '@otherinbox.com' account"
  end
end

use OmniAuth::Builder do
  provider :google_oauth2, ENV['GRAPHITI_CLIENT_ID'], ENV['GRAPHITI_CLIENT_SECRET'], {:access_type => 'online', :approval_prompt => ''}
end

run Graphiti

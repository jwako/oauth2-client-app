require 'sinatra'
require 'oauth2'
require 'json'
enable :sessions

APPLICATION_ID = "5638628d0fce794080fd9188c81a22d09d75051750d2f02f81b0759c2d1fa2a2"
APPLICATION_SECRET = "f764ae5c5ae481785515b66f13d639ce9b6a1d27ffa7e46d92ce79e11ab4fb28"
APPLICATION_SCOPES = "basic"
APPLICATION_URL = "http://localhost:3000"

def client
  OAuth2::Client.new(APPLICATION_ID, APPLICATION_SECRET, site: APPLICATION_URL)
end

get "/" do
  erb :index
end

get "/auth/test" do
  redirect client.auth_code.authorize_url(:redirect_uri => redirect_uri, scope: APPLICATION_SCOPES)
end

get '/auth/test/callback' do
  access_token = client.auth_code.get_token(params[:code], :redirect_uri => redirect_uri)
  session[:access_token] = access_token.token
  session[:refresh_token] = access_token.refresh_token
  @message = "Successfully authenticated!"
  erb :home
end

get '/me' do
  @message = get_response('users/me.json')
  erb :me
end

get '/home' do
  @message = "HOME"
  erb :home
end

get '/refresh' do
  access_token = OAuth2::AccessToken.new(client, session[:access_token], {refresh_token: session[:refresh_token]})
  new_token = access_token.refresh!
  session[:access_token] = new_token.token
  session[:refresh_token] = new_token.refresh_token
  @message = "Successfully refreshed!"
  erb :home
end

def get_response(url)
  access_token = OAuth2::AccessToken.new(client, session[:access_token])
  begin
    response = access_token.get("/api/v1/#{url}")
    JSON.parse(response.body)
  rescue => e
    JSON.parse(e.response.body)
  end

end

def redirect_uri
  uri = URI.parse(request.url)
  uri.path = '/auth/test/callback'
  uri.query = nil
  uri.to_s
end

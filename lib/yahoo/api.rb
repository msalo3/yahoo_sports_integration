require 'json'
require 'oauth2'
require 'rest-client'

module Yahoo
  class Api
    attr_accessor :client, :token

    def initialize(client_id, client_secret, redirect_uri)
      @url = "https://fantasysports.yahooapis.com/fantasy/v2/"
      @redirect_uri = redirect_uri

      @client = OAuth2::Client.new(client_id, client_secret, :site => @url)
    end

    def get_token
      client.auth_code.authorize_url(:redirect_uri => @redirect_uri)
      # => "https://example.org/oauth/authorization?response_type=code&client_id=client_id&redirect_uri=http://localhost:8080/oauth2/callback"

      @token = client.auth_code.get_token('authorization_code_value', :redirect_uri => 'http://localhost:8080/oauth2/callback', :headers => {'Authorization' => 'Basic some_password'})
    end

    def get_data
      response = token.get('/api/resource', :params => { 'query_foo' => 'bar' })
      response.class.name
    end


    # NOTE: I need to handle hourly token change
    # I should issue a try/catch or begin/rescue maybe?
    # Then write a function (private?? <-- should research this) for refreshing the token

    # If resfresh token is expired, just manual for now? How to handle?

    def get_league(id, sport)
      url_end = 'league/' + sport + '.l.' + id + '?format=json'
      data = RestClient.get @url + url_end, {:Authorization => 'Bearer ' + @access_token.to_s}
      puts data
      response = JSON.parse(data)
    end

    def request(url_end = "")
      data = JSON.parse(RestClient.get @url + url_end, {:Authorization => 'Bearer ' + @access_token.to_s})
    rescue RestClient::Unauthorized, RestClient::Forbidden => err
      puts 'Access denied'
      new_url = "https://api.login.yahoo.com/oauth2/get_token"
      response = RestClient::Request.execute method: :post, url: new_url, user: @key, password: @secret, payload: { redirect_uri: 'oob', grant_type: 'refresh_token', refresh_token: refresh_token}
      err.response
    else
      data
    end

  end
end

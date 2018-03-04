require 'json'
require 'rest-client'

module Yahoo
  class Api

    def initialize(key, secret, access_token, refresh_token)
      @url = "https://fantasysports.yahooapis.com/fantasy/v2/"
      @key = key
      @secret = secret
      @access_token = access_token
      @refresh_token = refresh_token
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

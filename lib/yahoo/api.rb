require 'json'
require 'rest-client'
require 'crack/xml'

module Yahoo
  class Api

    def initialize(key, secret, access_token, refresh_token)
      @url = "https://fantasysports.yahooapis.com/fantasy/v2/"
      @key = key
      @secret = secret
      @access_token = access_token
      @refresh_token = refresh_token
    end

    def get_league(id, sport)
      url_end = 'league/' + sport + '.l.' + id
      response = Crack::XML.parse(RestClient.get @url + url_end, {:Authorization => 'Bearer ' + @access_token.to_s })
    end

    # Get all products after 'since'
    # Returns an array of Yahoo::Product objects or raises an error
    def get_products(since='', page_number='')
      if page_number != '1' && page_number != '' && page_number
        response = RestClient.get @yahoo_url + 'products?per_page=' + @get_limit + '&page=' + page_number.to_s + @url_end
      elsif since && since != ''
        response = RestClient.get @yahoo_url + 'products?per_page=' + @get_limit + '&after=' + since.to_s + @url_end
      else
        response = RestClient.get @yahoo_url + 'products?per_page=' + @get_limit + @url_end
      end
    end
  end
end

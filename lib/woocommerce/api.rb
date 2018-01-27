require 'json'
require 'rest-client'

module Yahoo
  class Api
    attr_accessor :config, :payload

    def initialize(yahoo_url, consumer_key, consumer_secret)
      @yahoo_url = ('https://' + yahoo_url + '/wp-json/wc/v2/').delete(' ')
      @url_end = '&consumer_key=' + consumer_key + '&consumer_secret=' + consumer_secret
      @variation_url_end = '?consumer_key=' + consumer_key + '&consumer_secret=' + consumer_secret
      @get_limit = "50"
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

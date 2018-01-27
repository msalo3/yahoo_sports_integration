require "sinatra"
require "endpoint_base"
require "sinatra/reloader"
require 'honeybadger'

require_all 'lib'

class YahooIntegration < EndpointBase::Sinatra::Base
  # EndpointBase adds the following instance variables
  # @config which stores only "parameters" portion of an incoming request
  # @payload which seems to store the entire incoming request

  # Yahoo assumes all time to be in UTC
  Time.zone = 'UTC'
  set :timezone, Time.zone

  # Force Sinatra to autoreload this file or any file in the lib directory
  # when they change in development
  configure :development do
    register Sinatra::Reloader
    also_reload './lib/**/*'
  end

  post '/get_league' do
    begin

    result 200, "Success! This endpoint works!"
    rescue => e
      puts e.backtrace
      result 500, "Failed to get products: #{e.message}"
    end
  end

  # Return Product objects
  post '/get_products' do
    begin
      yahoo_api = new_yahoo_api_request(@payload, @config)
      now = settings.timezone.now.iso8601
      source = @config[:yahoo_host]
      id_prefix = @config[:yahoo_id_prefix]
      #Assume we only need 1 page for all products
      total_pages = 1
      # Set the current page to either 1 or whatever page number gets passed by FL
      current_page = @config[:yahoo_page_number] != '' && @config[:yahoo_page_number] ? @config[:yahoo_page_number] : 1
      current_page = current_page.to_i

      response = yahoo_api.get_products(@config[:yahoo_since], @config[:yahoo_page_number])
      current_page += 1
      if response.headers[:x_wp_totalpages].to_i > 1
        total_pages = response.headers[:x_wp_totalpages].to_i
      end
      products = JSON.parse(response.body)

      # Add products to FlowLink
      products.each do |product|
        # Get variations for each product
        variations = yahoo_api.get_variations product['id']
        yahoo_product = Yahoo::Product.new(product, variations, source, id_prefix)
        add_object :product, yahoo_product.as_flowlink_hash
      end

      add_parameter :yahoo_since, now

      number_of_products = products.length
      if current_page <= total_pages
        add_parameter :yahoo_page_number, current_page
        result 206, "Retrieved #{number_of_products.to_s} product(s). Getting load number: #{current_page.to_s}"
      elsif number_of_products > 0
        add_parameter :yahoo_page_number, 1
        result 200, "Successfully retrieved #{number_of_products.to_s} product(s)"
      else
        add_parameter :yahoo_page_number, 1
        result 200
      end
    rescue => e
      puts e.backtrace
      result 500, "Failed to get products: #{e.message}"
    end
  end

  private

    def new_yahoo_api_request(payload,config)
      yahoo_url = config[:yahoo_host]
      consumer_key = config[:yahoo_consumer_key]
      consumer_secret = config[:yahoo_consumer_secret]
      request_id = payload[:request_id]

      Yahoo::Api.new(yahoo_url, consumer_key, consumer_secret, request_id)
    end

end

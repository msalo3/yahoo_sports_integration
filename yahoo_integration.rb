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

  post '/test' do
    begin
      result 200, "Hit test endpoint and succeeded!"
    rescue => e
      puts e.backtrace
      result 500, 'Hit test endpoint, but failed somehow...'
    end
  end

  post '/get_league' do
    begin
      # Config object should contain the normal params as well as:
      #     "league_id": "9001",
      #     "sport": "nhl"
      yahoo_api = new_yahoo_api_request(@payload, @config)
      url_end = 'league/' + @config[:sport] + '.l.' + @config[:league_id] + '?format=json'
      league_info = yahoo_api.request(url_end)
      league_obj = Yahoo::League.new(league_info['fantasy_content']['league'].first).as_hash
      add_object :league, league_obj

      # We should eventually have a csv available as a download
      # Does the csv download automatically? Probably from the site itself...
      result 200, "Success! Retrieved data for league: #{league_obj[:name]}!"
    rescue => e
      puts e.backtrace
      result 500, "Failed to get League Data: #{e.message}"
    end
  end

  private

    def new_yahoo_api_request(payload,config)
      # The config object should look like this
      # {
      #   "parameters": {
      #     "yahoo_key": "1234",
      #     "yahoo_secret": "5678",
      #     "access_token": "",
      #     "refresh_token": "",
      #     etc
      #   }
      # }
      key = config[:yahoo_key]
      secret = config[:yahoo_secret]
      access_token = config[:access_token]
      refresh_token = config[:refresh_token]

      Yahoo::Api.new(key, secret, access_token, refresh_token)
    end
end

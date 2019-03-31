ruby '2.4.2'
source 'https://rubygems.org'

gem 'sinatra'
gem 'tilt', '~> 1.4.1'
gem 'tilt-jbuilder'
gem 'jbuilder', '2.0.7'
gem 'capistrano'
gem 'rest-client'
gem 'require_all'
gem 'honeybadger', '~> 2.0'
gem 'nokogiri'
gem 'crack'
gem 'oauth2'

group :development do
  gem 'shotgun'
  gem 'pry'
  gem 'awesome_print'
end

group :test do
  gem 'vcr'
  gem 'rspec'
  gem 'webmock'
  gem 'guard-rspec'
  gem 'terminal-notifier-guard'
  gem 'rb-fsevent', '~> 0.9.1'
  gem 'rack-test'
end

group :production do
  gem 'foreman'
  gem 'unicorn'
end

gem 'endpoint_base', github: 'flowlink/endpoint_base'
gem 'sinatra-contrib' # For sinatra/reloader which autoreloads modules on change

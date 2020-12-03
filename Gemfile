# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '>= 6.0.3.3'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.4.4'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

gem 'api-pagination'
gem 'devise'
gem 'goggles_db', git: 'https://github.com/steveoro/goggles_db'
gem 'grape'
gem 'grape_logging'
gem 'grape-route-helpers'
gem 'kaminari'
gem 'rest-client'
gem 'simple_command'

# Inherited data factories from DB engine, published also on production/staging
# to allow fixture creation for testing purposes:
gem 'factory_bot_rails'
gem 'ffaker'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'

  gem 'guard'
  gem 'guard-brakeman'
  gem 'guard-bundler', require: false
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'guard-spring'
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-commands-rubocop'
  gem 'spring-watcher-listen'
end

group :development, :test do
  gem 'awesome_print' # color output formatter for Ruby objects
  gem 'brakeman'
  gem 'bullet'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'letter_opener'
  gem 'pry'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'rubocop', require: false # For style checking
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
end

group :test do
  gem 'codeclimate-test-reporter', require: false
  gem 'codecov', require: false
  gem 'coveralls', require: false
  gem 'n_plus_one_control' # Adds DSL to check for "N+1 queries" directly in test environment ('bullet' works best just on development)
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

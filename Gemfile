source 'https://rubygems.org'

gem 'rails', '4.2.5.2'

# NB: this *must* be by Git ref; else will break asset versioning in
#     config/initializers/assets.rb, preventing app startup
gem 'europeana-styleguide', github: 'europeana/europeana-styleguide-ruby', ref: '48883a4'

# Use a forked version of stache with downstream changes, until merged upstream
# @see https://github.com/agoragames/stache/pulls/rwd
gem 'stache', github: 'europeana/stache', branch: 'europeana-styleguide'

gem 'aasm', '~> 4.2'
gem 'blacklight', '~> 6.0.0'
gem 'acts_as_list', '~> 0.7'
gem 'cancancan', '~> 1.12'
gem 'clockwork', '~> 1.2'
gem 'colorize'
gem 'sidekiq'
gem 'devise', '~> 3.5.4'
gem 'europeana-blacklight', '~> 0.4.2', github: 'europeana/europeana-blacklight', ref: '813baa4'
gem 'europeana-api', '~> 0.5.0'
gem 'feedjira', '~> 2.0'
gem 'fog', '~> 1.33'
gem 'globalize', '~> 5.0'
gem 'globalize-versioning', github: 'globalize/globalize-versioning'
gem 'htmlcompressor', '0.3'
gem 'nokogiri', '~> 1.6.7.2'
gem 'ruby-oembed', '~> 0.9'
gem 'pg'
gem 'paperclip', '~> 4.3'
gem 'paper_trail', '~> 4.0'
gem 'puma', '~> 2.13'
gem 'rack-rewrite'
gem 'rails_admin', '~> 0.8.0'
gem 'redis-namespace'
gem 'redis-rails', '~> 4.0'
gem 'redis-rails-instrumentation'
gem 'sass-rails'
gem 'soundcloud', '~> 0.3'
gem 'therubyracer'

group :production do
  gem 'rails_12factor', '~> 0.0.3'
  gem 'uglifier', '~> 2.7.2'
end

group :development, :test do
  gem 'dotenv-rails', '~> 2.0'
  gem 'rspec-rails', '~> 3.0'
  gem 'rubocop', '0.35.1', require: false # only update when Hound does
end

group :development do
  gem 'foreman'
  gem 'spring', '~> 1.6'
  gem 'web-console', '~> 3.0'
end

group :test do
  gem 'capybara', '~> 2.5'
  gem 'coveralls', require: false
  gem 'phantomjs', require: 'phantomjs/poltergeist'
  gem 'poltergeist'
  gem 'selenium-webdriver', '~> 2.47'
  gem 'shoulda-matchers', '~> 3.0', require: false
  gem 'simplecov', require: false
  gem 'webmock', '~> 1.22'
end

group :doc do
  gem 'yard'
end

group :localeapp do
  gem 'localeapp', '~> 1.0'
end

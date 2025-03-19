require 'logger'
require 'bundler'
Bundler.require

require './app'

ActiveRecord::Base.configurations = YAML.load_file('config/database.yml')
ActiveRecord::Base.establish_connection(:development)
Time.zone = 'Tokyo'
ActiveRecord::Base.default_timezone = :local

run Sinatra::Application

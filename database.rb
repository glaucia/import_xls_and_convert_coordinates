require 'mysql2'
require 'active_record'
require 'yaml'

puts ("require 1 database")
dbconfigs = YAML::load(File.open('database.yml'))        
ActiveRecord::Base.establish_connection(dbconfigs['banco'])



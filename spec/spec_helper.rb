require 'bundler'
Bundler.setup(:default, :test)
require 'rspec'
require 'rspec/autorun'
require 'mongoid_embedded_helper'

RSpec.configure do |config|
  # config.mock_with :mocha
end

Mongoid.configure.master = Mongo::Connection.new.db('acts_as_list-test')
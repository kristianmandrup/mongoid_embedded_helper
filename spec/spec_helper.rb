require 'bundler'
Bundler.setup(:default, :test)
require 'rspec'
require 'rspec/autorun'
require 'mongoid_embedded_helper'
require 'simplecov'
require 'pry'

SimpleCov.start
RSpec.configure do |config|
  # config.mock_with :mocha
end

Mongoid.configure.connect_to('acts_as_list-test')

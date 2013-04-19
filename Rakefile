# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
    gem.name = "mongoid_embedded_helper"
    gem.summary = %Q{Facilitates performing queries on collections in embedded Mongoid documents}
    gem.description = %Q{Facilitates performing queries on collections in embedded Mongoid documents by performing query from the root node}
    gem.email = "kmandrup@gmail.com"
    gem.homepage = "http://github.com/kristianmandrup/mongoid_embedded_helper"
    gem.authors = ["Kristian Mandrup"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :default => :spec


require 'rdoc/task'
RDoc::Task.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "mongoid_embedded_helper #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end




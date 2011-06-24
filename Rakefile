require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "mongoid_embedded_helper"
    gem.summary = %Q{Facilitates performing queries on collections in embedded Mongoid documents}
    gem.description = %Q{Facilitates performing queries on collections in embedded Mongoid documents by performing query from the root node}
    gem.email = "kmandrup@gmail.com"
    gem.homepage = "http://github.com/kristianmandrup/mongoid_embedded_helper"
    gem.authors = ["Kristian Mandrup"]
    gem.add_dependency "mongoid",           ">= 2.0.0.rc.7"
    gem.add_dependency "mongoid_adjust",    ">= 0.1.1"
    gem.add_dependency "bson_ext",          ">= 1.0.8"

    gem.add_development_dependency "rspec", ">= 2.4.0"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

# Mongoid embedded helper #

The Mongoid EmbeddedHelper helps overcome the limitation that you can't perform direct queries on an embedded collection without accessing it from the root.
It simply introduces a generic function that performs the "local" query by accessing it from the nearest root ;)

## Installation ##  

<code>gem install mongoid_embedded_helper</code>

## Usage ##

Mongoid doesn't allow you to perform direct queries on an embedded collection. You have to access the embedded collection from the root in order to do this.
To overcome this limitation, use the EmbeddedHelper module to add a method <code>query_class</code> which will find the closest non-embedded node in the hierarchy and
then traverse down the path back to the object, so that you can perform the query on the embedded collection.

<code>
require 'mongoid_embedded_helper'

class Item
  include Mongoid::Document      
  include Mongoid::EmbeddedHelper
  field :pos, :type => Integer  
  field :number, :type => Integer  
  
  field :assoc, :type => Symbol
  embedded_in :list, :inverse_of => :items   
end

item = @person.lists[0].items[0]
item.query_class.where(:number.gt => 1).to_a  
  
</code>

## Copyright ##

Copyright (c) <2010> <Kristian Mandrup>
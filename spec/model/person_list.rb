class Person
  include Mongoid::Document
  include Mongoid::EmbeddedHelper
  field :name, :type => String
  embeds_many :lists 
  
  # after_update :do_it    
  # def do_it
  #   puts "hello"
  # end
end  

class PosPerson
  include Mongoid::Document
  include Mongoid::EmbeddedHelper
  field :pos, :type => Integer
  field :name, :type => String
  embeds_many :lists   
end  


class List
  include Mongoid::Document
  include Mongoid::EmbeddedHelper
  field :pos, :type => Integer  
  field :name, :type => String
  embedded_in :person, :inverse_of => :lists
  
  embeds_many :items     
end


class Item
  include Mongoid::Document      
  include Mongoid::EmbeddedHelper
  field :pos, :type => Integer  
  field :number, :type => Integer  
  field :name, :type => String  
  field :assoc, :type => Symbol
  embedded_in :list, :inverse_of => :items   
end        
   

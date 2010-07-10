class SimpleList
  include Mongoid::Document
  field :pos, :type => Integer  
  field :name, :type => String
  embeds_many :simple_items     
end


class SimpleItem
  include Mongoid::Document      
  include Mongoid::EmbeddedHelper
  field :pos, :type => Integer  
  field :number, :type => Integer  
  field :name, :type => String   
  field :assoc, :type => Symbol

  embedded_in :simple_list, :inverse_of => :simple_items 

  field :assimilated, :type => Boolean, :default => false  
  field :parentized, :type => Boolean, :default => false  
  
  def after_parentize
    self.parentized = true    
  end  
  
  def after_assimilate
    self.assimilated = true
  end  
end
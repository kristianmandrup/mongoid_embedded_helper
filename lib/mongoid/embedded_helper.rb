require 'mongoid'

module Mongoid
  module EmbeddedHelper                      
    def in_collection stack = []
      stack.extend(ArrayExt) if stack.empty?
      if embedded?        
        stack.add_collection_name self
        _parent.in_collection(stack)
      else  
        return self.class if stack.empty?      
        iterate_collection_stack stack
      end
    end
    
    private 
         
    def iterate_collection_stack stack
      collection = self
      stack = stack.reverse
      stack.each do |entry|
        sub_collection = collection.send entry[:collection_name]    
        index = sub_collection.to_a.index(entry[:object]) if entry != stack.last        
        collection = sub_collection[index] if index
        collection = sub_collection  if !index
      end
      collection
    end
    
    module ArrayExt
      def add_collection_name obj
        self << {:collection_name => obj.collection_name, :object => obj}
      end      
    end    
  end
end

class NilClass
  def integer?
    false
  end
end

module Mongoid::Extensions::Array
  module Mutators
    def adjust!(attrs = {})
      attrs.each_pair do |key, value|
        self.each do |doc|
          doc.adjust!(attrs)
        end
      end
      self
    end  
  end
end

module Mongoid
  class Criteria
    def adjust!(attrs = {})
      to_a.adjust!(attrs)
    end  
  end
end
     
module Mongoid::Document        
  def present? key
    respond_to? key    
  end
  
  def adjust!(attrs = {}) 
    run_callbacks(:before_update)              
    (attrs || {}).each_pair do |key, value|
      next if !value.integer? # only add integer values     
      next if !present? key # only add to properties already present!
      
      if set_allowed?(key)
        current_val = @attributes[key.to_s] || 0

        if current_val.integer?
          @attributes[key.to_s] = current_val + value 
        end

      elsif write_allowed?(key)
        current_val = send("#{key}") || 0

        if current_val.integer?    
          send("#{key}=", current_val + value) 
        end
      end 
    end
    identify if id.blank?
    notify
    run_callbacks(:after_update)
    self
  end
end

class Array
  include Mongoid::Extensions::Array::Mutators
end

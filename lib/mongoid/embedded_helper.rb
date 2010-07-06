require 'mongoid'

module Mongoid
  module EmbeddedHelper                      
    def in_collection stack = []
      stack.extend(ArrayExt) if stack.empty?
      if embedded? 
        stack.add_collection_name self
        if _parent.respond_to?(:in_collection)
          _parent.in_collection(stack)
        else
          iterate_collection_stack stack, _parent
        end
      else  
        return self.class if stack.empty?      
        iterate_collection_stack stack
      end
    end
    
    private 
         
    def iterate_collection_stack stack, subject = nil
      collection = subject || self
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
    (attrs || {}).each_pair do |key, value|
      next if !present? key # only add to properties already present!
      adjust_by_proc!(key, value) if value.kind_of?(Proc)
      adjust_by_symbol!(key, value) if value.kind_of?(Symbol) || value.kind_of?(String)
      adjust_by_number!(key, value) if value.kind_of?(Numeric) # only add integer values     
    end
    self
  end  

  private 

  def adjust_by_proc! key, proc
    if set_allowed?(key)
      current_val = @attributes[key.to_s]
      @attributes[key.to_s] = proc.call(current_val)
    elsif write_allowed?(key)
      current_val = send("#{key}")
      send("#{key}=", proc.call(current_val))
    end     
  end

  def adjust_by_symbol! key, name
    method = name.to_sym
    if set_allowed?(key)
      current_val = @attributes[key.to_s]
      @attributes[key.to_s] = current_val.send(method)
    elsif write_allowed?(key)
      current_val = send("#{key}")
      send("#{key}=", current_val.send(method))
    end     
  end

  
  def adjust_by_number! key, value
    if set_allowed?(key)
      current_val = @attributes[key.to_s] || 0

      if current_val.kind_of? Numeric
        @attributes[key.to_s] = current_val + value 
      end

    elsif write_allowed?(key)
      current_val = send("#{key}") || 0

      if current_val.kind_of? Numeric
        send("#{key}=", current_val + value) 
      end
    end 
  end
    
end

class Array
  include Mongoid::Extensions::Array::Mutators
end

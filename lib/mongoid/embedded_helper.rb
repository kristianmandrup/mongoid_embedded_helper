require 'mongoid'

module Mongoid
  module EmbeddedHelper                  
    def query_class stack = []
      stack.extend(ArrayExt) if stack.empty?
      if embedded?        
        stack.add_collection_name self
        _parent.query_class(stack)
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

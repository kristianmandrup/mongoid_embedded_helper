require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

Mongoid.configure.master = Mongo::Connection.new.db('acts_as_list-test')

class List
  include Mongoid::Document
  field :pos, :type => Integer  
  field :name, :type => String
  embeds_many :items     
end


class Item
  include Mongoid::Document      
  include Mongoid::EmbeddedHelper
  field :pos, :type => Integer  
  field :number, :type => Integer  
  field :name, :type => String   
  field :assoc, :type => Symbol

  field :assimilated, :type => Boolean, :default => false  
  field :parentized, :type => Boolean, :default => false  

  embedded_in :list, :inverse_of => :items 
  
  def after_parentize
    self.parentized = true    
  end  

  def after_assimilate
    self.assimilated = true
  end  
end    

describe 'Mongoid Embedded Helper' do
  before :each do
    @list = List.create! :pos => 1, :name => 'My list'
    item_names = ('A'..'C').to_a
    (1..3).each do |counter|
      item = Item.new :pos => counter, :number => counter, :name => item_names[counter-1]
      @list.items << item  
    end
    @list.save!
  end
  
  after :each do
    Mongoid.database.collections.each do |coll|
      coll.remove
    end
  end  
     
  describe '#in_collection' do    
    it "should handle query from leaf node without List (non-embedded root node) includes Embedded::Helper" do
      result = @list.items[0].in_collection.where(:pos => 2).to_a.first  
      result.pos.should == 2
      result.number.should == 2
      result.name.should == 'B'      
    end
  end  
  
  describe 'new callbacks' do    
    context 'item with callbacks added to parent' do
      it "should call :after_parentize callback" do
        @list.items[0].parentized.should be_true
      end
      
      it "should NOT call :after_assimilate callback" do
        @list.items[0].assimilated.should be_false
      end
    end
  end  
end


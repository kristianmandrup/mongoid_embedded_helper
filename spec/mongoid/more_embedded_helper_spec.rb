require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'model/list'

describe 'Mongoid Embedded Helper' do
  before :each do
    @list = SimpleList.create! :pos => 1, :name => 'My list'
    item_names = ('A'..'C').to_a
    (1..3).each do |counter|
      item = SimpleItem.new :pos => counter, :number => counter, :name => item_names[counter-1]
      @list.simple_items << item  
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
      result = @list.simple_items[0].in_collection.where(:pos => 2).to_a.first  
      result.pos.should == 2
      result.number.should == 2
      result.name.should == 'B'      
    end
  end
  
  describe 'extra callbacks' do    
    context 'item with callbacks added to parent' do
      it "should call :after_parentize callback" do
        @list.simple_items[0].parentized.should be_true
      end
      
      it "should NOT call :after_assimilate callback" do
        @list.simple_items[0].assimilated.should be_false
      end
    end
  end  
end


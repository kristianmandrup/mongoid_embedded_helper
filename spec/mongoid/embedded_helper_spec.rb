require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

Mongoid.configure.master = Mongo::Connection.new.db('acts_as_list-test')

class Person
  include Mongoid::Document
  include Mongoid::EmbeddedHelper
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
  
  field :assoc, :type => Symbol
  embedded_in :list, :inverse_of => :items   
end    

describe 'Mongoid Embedded Helper' do

  before :each do
    @person = Person.create! :name => 'Kristian'
    # person.lists = []               
    list = List.new :pos => 1, :name => 'My list'
    (1..3).each do |counter|  
      item = Item.new :pos => counter, :number => counter
      list.items << item  
    end
    @person.lists << list
    @person.save!
  end
  
  after :each do
    Mongoid.database.collections.each do |coll|
      coll.remove
    end
  end  
     
  describe '#top level query' do
  
    it "should handle query from top level node" do
      result = @person.in_collection.where(:name => 'Kristian').to_a.first  
      result.name.should == 'Kristian'
    end
  
    it "should handle query from mid level node" do
      result = @person.lists[0].in_collection.where(:name => 'My list').to_a.first  
      result.name.should == 'My list'
    end
  
    it "should handle query from mid level node" do
      result = @person.lists[0].items[0].in_collection.where(:number.gt => 1).to_a  
      result.size.should == 2
    end
  end  
end


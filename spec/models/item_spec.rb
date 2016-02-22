require 'rails_helper'

class Item < ActiveRecord::Base
  validates :name, presence: true
end

class Item < ActiveRecord::Base
  validates :name, :description, presence: true
end

RSpec.describe Item, type: :model do
  it 'is invalid without a name' do
    item = Item.new(name: nil)
    expect(item).not_to be_valid
  end

  it 'is invalid without a description' do
    item = Item.new(name: 'xName', description: nil)
    expect(item).not_to be_valid
  end
end

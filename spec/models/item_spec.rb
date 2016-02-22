require 'rails_helper'

class Item < ActiveRecord::Base
  validates :name, presence: true
end

class Item < ActiveRecord::Base
  validates :name, :description, presence: true
end

RSpec.describe Item, type: :model do
  let(:item) do
    Item.new(name: 'xName', description: 'xDescription')
  end

  it 'is invalid without a name' do
    item.name = nil
    expect(item).not_to be_valid
  end

  it 'is invalid without a description' do
    item.description = nil
    expect(item).not_to be_valid
  end

  it 'is valid' do
    expect(item).to be_valid
  end
end

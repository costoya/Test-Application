require 'rails_helper'

describe 'Insert element', type: :feature do

  let(:item) do
    Item.new(name: 'xName', description: 'xDescription')
  end

  before(:each) do
    Capybara.current_driver = Capybara.javascript_driver
  end

  after(:each) do
    deleteItem(item)
  end

  it 'is happy path' do
    Rails.logger.info('X1, X12, X15')
    time = Time.now
    item.name = 'xName' + time.inspect
    item.description = 'xDescription' + time.inspect
    createPage(item)
    checkValid(item)
    page.click_link('Back')
    checkValid(item)
    page.click_link('Show')
    checkValid(item)
  end

  it 'has strange characters' do
    Rails.logger.info('X13, X16')
    time = Time.now
    item.name = "漢字áéñç<a href='http://www.xing.com>test</a>'" + time.inspect
    item.description = "漢字áéñç<a href='http://www.xing.com>test</a>'" + time.inspect
    createPage(item)
    checkValid(item)
    page.click_link('Back')
    checkValid(item)
    item.name = '漢字áéñç'
  end

  it 'puts empty values' do
    Rails.logger.info('X2')
    item.name = ''
    item.description = ''
    createPage(item)
    expect(page).to have_content('3 errors prohibited this item from being saved:');
  end

  it 'has Huge size' do
    Rails.logger.info('X3, X14, X17')
    time = Time.now
    item.name = '123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890' + time.inspect
    item.description = '123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890' + time.inspect
    createPage(item)
    checkValid(item)
    page.click_link('Back')
    checkValid(item)
  end

  it 'is cancelled pressing back' do
    Rails.logger.info('X4')
    visit '/items'
    page.click_link('New Item')
    page.click_link('Back')
    page.has_content?('Listing Items')
  end
end

describe 'Delete element', type: :feature do
  let(:item) do
    Item.new(name: 'xName', description: 'xDescription')
  end

  before(:each) do
    Capybara.current_driver = Capybara.javascript_driver
    time = Time.now
    item.name = 'xName' + time.inspect
    item.description = 'xDescription' + time.inspect
    createPage(item)
    page.click_link('Back')
    find(:xpath, "//td[text()='"+item.name+"']/..//a[contains(text(), 'Destroy')]").click
  end

  after(:each) do
    deleteItem(item)
  end

  it 'is happy path' do
    Rails.logger.info('X5')
    page.driver.browser.switch_to.alert.accept
    expect(page).to have_content('Item was successfully destroyed.')
  end

  it 'is cancelled' do
    Rails.logger.info('X6')
    page.driver.browser.switch_to.alert.dismiss
    expect(page).to have_content(item.name)
  end
end

describe 'Edit element', type: :feature do
  let(:item) do
    Item.new(name: 'xName', description: 'xDescription')
  end

  before(:each) do
    Capybara.current_driver = Capybara.javascript_driver
    time = Time.now
    item.name = 'xName' + time.inspect
    item.description = 'xDescription' + time.inspect
    createPage(item)
    page.click_link('Back')
  end

  after(:each) do
    deleteItem(item)
  end

  it 'is happy path' do
    Rails.logger.info('X7, X19')
    itemNew = item.dup
    itemNew.name = itemNew.name + 'Edited'
    itemNew.description = itemNew.description + 'Edited'
    editItem(item, itemNew)
    expect(page).to have_content('Item was successfully updated.')
    checkValid(itemNew)
  end

  it 'has empty values' do
    Rails.logger.info('X8')
    itemNew = Item.new
    itemNew.name = ''
    itemNew.description = ''
    editItem(item, itemNew)
    expect(page).to have_content('3 errors prohibited this item from being saved:');
  end

  it 'has huge values' do
    Rails.logger.info('X9')
    itemNew = item.dup
    itemNew.name = itemNew.name + '123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890'
    itemNew.description = itemNew.description + '123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890'
    editItem(item, itemNew)
    expect(page).to have_content('Item was successfully updated.')
    checkValid(itemNew)
  end

  it 'cancels editing' do
    Rails.logger.info('X10, X12')
    find(:xpath, "//td[text()='" + item.name + "']/..//a[contains(text(), 'Edit')]").click
    page.click_link('Back')
    expect(page).to have_content('Listing Items')
    checkValid(item)
  end

  it 'shows the editing' do
    Rails.logger.info('X11')
    itemNew = item.dup
    itemNew.name = itemNew.name + 'Edited'
    itemNew.description = itemNew.description + 'Edited'
    find(:xpath, "//td[text()='" + item.name + "']/..//a[contains(text(), 'Edit')]").click
    fillValues(itemNew)
    page.click_link('Show')
    expect(page).to have_content(item.name)
    expect(page).to have_content(item.description)
  end
end

def fillValues(item)
  Rails.logger.debug('Enter: fillValues - name: ' + item.name + ' - description: ' + item.description)
  page.fill_in('item_name', with: item.name)
  page.fill_in('item_description', with: item.description)
  Rails.logger.debug('Exit: fillValues - name: ' + item.name + ' - description: ' + item.description)
end

def editItem(oldItem, newItem)
  Rails.logger.debug('Enter: editItem - oldName: ' + oldItem.name + ' - oldDescription: ' + oldItem.description + ' - newName: ' + newItem.name + ' - newDescription: ' + newItem.description)
  find(:xpath, "//td[text()='" + oldItem.name + "']/..//a[contains(text(), 'Edit')]").click
  fillValues(newItem)
  page.click_button('Update Item')
  Rails.logger.debug('Exit: editItem - oldName: ' + oldItem.name + ' - oldDescription: ' + oldItem.description + ' - newName: ' + newItem.name + ' - newDescription: ' + newItem.description)
end

def createPage(item)
  Rails.logger.debug('Enter: createPage - name: ' + item.name + ' - description: ' + item.description)
  visit '/items'
  page.click_link('New Item')
  url = URI.parse(current_url)
  expect(url.path).to eq('/items/new')
  fillValues(item)
  page.click_button('Create Item')
  Rails.logger.debug('Exit: createPage - name: ' + item.name + ' - description: ' + item.description)
end

def checkValid(item)
  Rails.logger.debug('Enter: checkValid - name: ' + item.name.inspect + ' - description: ' + item.description.inspect)
  expect(page).to have_content(item.name)
  expect(page).to have_content(item.description)
  Rails.logger.debug('Exit: checkValid - name: ' + item.name.inspect + ' - description: ' + item.description.inspect)
end

def deleteItem(item)
  begin
    visit '/items'
    find(:xpath, "//td[contains(text(),'" + item.name + "')]/..//a[contains(text(), 'Destroy')]").click
    page.driver.browser.switch_to.alert.accept
    Rails.logger.debug('Element ' + item.name + ' was deleted.')
  rescue Capybara::ElementNotFound
    Rails.logger.debug('Unable to delete item')
  end
end
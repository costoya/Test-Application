require 'rails_helper'

describe 'Insert element', type: :feature do

  before(:each) do
    Capybara.current_driver = Capybara.javascript_driver
  end

  after(:each) do
    deleteItem($name)
  end

  it 'is happy path' do
    Rails.logger.info("New Item – Happy path")
    time = Time.now
    $name = 'xName' + time.inspect
    description = 'xDescription' + time.inspect
    createPage($name, description)
    checkValid($name, description)
  end

  it 'has strange characters' do
    Rails.logger.info("New Item – Happy path")
    time = Time.now
    $name = "漢字áéñç<a href='http://www.xing.com>test</a>'" + time.inspect
    description = "漢字áéñç<a href='http://www.xing.com>test</a>'" + time.inspect
    createPage($name, description)
    checkValid($name, description)
    $name = "漢字áéñç"
  end

  it 'puts empty values' do
    Rails.logger.info("New Item – Empty values")
    $name = ''
    description = ''
    createPage($name, description)
    expect(page).to have_content("3 errors prohibited this item from being saved:");
  end

  it 'has Huge size' do
    Rails.logger.info("New Item – Huge size")
    time = Time.now
    $name = '123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890' + time.inspect
    description = '123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890' + time.inspect
    createPage($name, description)
    checkValid($name, description)
  end

  it 'is cancelled pressing back' do
    Rails.logger.info("New Item – Back")
    visit '/items'
    page.click_link("New Item")
    page.click_link("Back")
    page.has_content?("Listing Items")
  end
end

describe 'Delete element', type: :feature do
  before(:each) do
    Capybara.current_driver = Capybara.javascript_driver
    time = Time.now
    $name = 'xName' + time.inspect
    description = 'xDescription' + time.inspect
    createPage($name, description)
    page.click_link("Back")
    find(:xpath, "//td[text()='"+$name+"']/..//a[contains(text(), 'Destroy')]").click
  end

  after(:each) do
    deleteItem($name)
  end

  it 'is happy path' do
    Rails.logger.info("Delete Item – Happy path")
    page.driver.browser.switch_to.alert.accept
    expect(page).to have_content("Item was successfully destroyed.")
  end

  it 'is cancelled' do
    Rails.logger.info("Destroy – Cancel")
    page.driver.browser.switch_to.alert.dismiss
    expect(page).to have_content($name)
  end
end

describe 'Edit element', type: :feature do
  before(:each) do
    Capybara.current_driver = Capybara.javascript_driver
    time = Time.now
    $name = 'xName' + time.inspect
    $description = 'xDescription' + time.inspect
    createPage($name, $description)
    page.click_link("Back")
  end

  after(:each) do
    deleteItem($name)
  end

  it 'is happy path' do
    Rails.logger.info("Edit Item – Happy path")
    nameNew = $name + "Edited"
    descriptionNew = $description + "Edited"
    editItem($name, $description, nameNew, descriptionNew)
    expect(page).to have_content("Item was successfully updated.")
    checkValid($nameNew, descriptionNew)
  end

  it 'has empty values' do
    Rails.logger.info("Edit Item – Empty values")
    editItem($name, $description, '', '')
    expect(page).to have_content("3 errors prohibited this item from being saved:");
  end

  it 'has huge values' do
    Rails.logger.info("Edit Item – Huge size")
    nameNew = $name + '123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890'
    descriptionNew = $description + '123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890'
    editItem($name, $description, nameNew, descriptionNew)
    expect(page).to have_content("Item was successfully updated.")
    checkValid(nameNew, descriptionNew)
  end

  it 'cancels editing' do
    Rails.logger.info("Edit Item – Back")
    find(:xpath, "//td[text()='" + $name + "']/..//a[contains(text(), 'Edit')]").click
    page.click_link("Back")
    expect(page).to have_content("Listing Items")
  end

  it 'shows the editing' do
    Rails.logger.info("Edit Item – Show")
    nameNew = $name + "Edited"
    descriptionNew = $description + "Edited"
    find(:xpath, "//td[text()='" + $name + "']/..//a[contains(text(), 'Edit')]").click
    fillValues(nameNew, descriptionNew)
    page.click_link("Show")
    expect(page).to have_content($name)
    expect(page).to have_content($description)
  end
end

def fillValues(name, description)
  Rails.logger.debug("Enter: fillValues - name: " + name + " - description: " + description)
  page.fill_in('item_name', with: name)
  page.fill_in('item_description', with: description)
  Rails.logger.debug("Exit: fillValues - name: " + name + " - description: " + description)
end

def editItem(oldName, oldDescription, newName, newDescription)
  Rails.logger.debug("Enter: editItem - oldName: " + oldName + " - oldDescription: " + oldDescription + " - newName: " + newName + " - newDescription: " + newDescription)
  find(:xpath, "//td[text()='" + oldName + "']/..//a[contains(text(), 'Edit')]").click
  fillValues(newName, newDescription)
  page.click_button("Update Item")
  Rails.logger.debug("Enter: editItem - oldName: " + oldName + " - oldDescription: " + oldDescription + " - newName: " + newName + " - newDescription: " + newDescription)end

def createPage(name, description)
  Rails.logger.debug("Enter: createPage - name: " + name + " - description: " + description)
  visit '/items'
  page.click_link("New Item")
  url = URI.parse(current_url)
  expect(url.path).to eq("/items/new")
  fillValues(name, description)
  page.click_button('Create Item')
  Rails.logger.debug("Exit: createPage - name: " + name + " - description: " + description)
end

def checkValid(name, description)
  Rails.logger.debug("Enter: checkValid - name: " + name.inspect + " - description: " + description.inspect)
  expect(page).to have_content(name)
  expect(page).to have_content(description)
  Rails.logger.debug("Exit: checkValid - name: " + name.inspect + " - description: " + description.inspect)
end

def deleteItem(name)
  begin
    visit "/items"
    find(:xpath, "//td[contains(text(),'" + name + "')]/..//a[contains(text(), 'Destroy')]").click
    page.driver.browser.switch_to.alert.accept
    Rails.logger.debug("Element " + name + " was deleted.")
  rescue Capybara::ElementNotFound
    Rails.logger.debug("Unable to delete item")
  end
end
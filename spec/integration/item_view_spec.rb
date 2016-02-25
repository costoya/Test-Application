require 'rails_helper'

describe 'Insert element', type: :feature do

  before(:each) do
#    Capybara.current_driver = Capybara.javascript_driver
  end

  it 'is happy path' do
    puts "New Item – Happy path"
    time = Time.now
    name = 'xName' + time.inspect
    description = 'xDescription' + time.inspect
    createPage(name, description)
    checkValid(name, description)
  end

  it 'puts empty values' do
    puts "New Item – Empty values"
    name = ''
    description = ''
    createPage(name, description)
    expect(page).to have_content("3 errors prohibited this item from being saved:");
  end

  it 'has Huge size' do
    puts "New Item – Huge size"
    time = Time.now
    name = '123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890' + time.inspect
    description = '123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890' + time.inspect
    createPage(name, description)
    checkValid(name, description)
  end

  it 'is cancelled pressing back' do
    puts "New Item – Back"
    visit '/items'
    page.click_link("New Item")
    page.click_link("Back")
    page.has_content?("Listing Items")
  end

  def checkValid(name, description)
    expect(page).to have_content(name)
    expect(page).to have_content(description)
  end
end

describe 'Delete element', type: :feature do
  before(:each) do
#    Capybara.current_driver = Capybara.javascript_driver
    time = Time.now
    $name = 'xName' + time.inspect
    description = 'xDescription' + time.inspect
    createPage($name, description)
    page.click_link("Back")
    find(:xpath, "//td[text()='"+$name+"']/..//a[contains(text(), 'Destroy')]").click
  end

  it 'is happy path' do
    puts "Delete Item – Happy path"
    page.driver.browser.switch_to.alert.accept
    expect(page).to have_content("Item was successfully destroyed.")
  end

  it 'is cancelled' do
    puts "Destroy – Cancel"
    page.driver.browser.switch_to.alert.dismiss
    expect(page).to have_content($name)
  end
end

def createPage(name, description)
  visit '/items'
  page.click_link("New Item")
  url = URI.parse(current_url)
  expect(url.path).to eq("/items/new")
  fillValues(name, description)
  page.click_button('Create Item')
end
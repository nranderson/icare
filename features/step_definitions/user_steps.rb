# encoding: utf-8
When /^a guest tries to access a protected page$/ do
  visit '/dashboard'
end

When /^a guest gives access permission to this application on Facebook$/ do
  visit '/auth/facebook'
end

When /^a guest logs in on itinerary page$/ do
  @itinerary = FactoryGirl.create :itinerary
  visit itinerary_path(@itinerary)
  find('a', text: /Login with Facebook/i).click
end

Then /^he should be redirected to the itinerary page$/ do
  expect(page).to have_xpath '//title', @itinerary.title
  expect(page).to have_content @itinerary.user_name
end

Then /^he should see an? "([^"]*)" message "([^"]*)"$/ do |css_class, message|
  expect(page.find(".alert-#{css_class}")).to have_content message
end

Then /^he should not see an? "([^"]*)" message "([^"]*)"$/ do |css_class, message|
  -> { page.find(".alert-#{css_class}") }.should raise_error Capybara::ElementNotFound
  page.should_not have_content message
end

Then /^he should fail to log in$/ do
  page.should have_content 'Login failed, please retry.'
end

Then /^he should be logged in$/ do
  within('.navbar-inner') do
    expect(page.find("a[href='/signout']")).to be_present
  end
end

Then /^he should not be logged in$/ do
  within('.navbar-inner') do
    page.has_no_selector? "a[href='/logout']"
  end
end

Then /^a new user should be added to database$/ do
  expect(User.count).to_not be_zero
end

Then /^he should be able to log out$/ do
  visit '/signout'
end

Then /^he should see the log in button$/ do
  expect(page).to have_content 'Login with Facebook'
end

require 'spec_helper'

feature "User signs up" do 

  scenario "when being logged out" do
  	expect{ sign_up }.to change(User, :count).by(1)
  	expect(page).to have_content("Welcome, alice@example.com")
  	expect(User.first.email).to eq("alice@example.com")
  end

  scenario "with a password that doesn't match" do
    expect{ sign_up('a@a.com', 'pass', 'wrong') }.to change(User, :count).by(0)
    expect(current_path).to eq('/users')
    expect(page).to have_content("Sorry, your passwords don't match")
  end

  scenario "with an email that is already registered" do
    expect{ sign_up }.to change(User, :count).by(1)
    expect{ sign_up }.to change(User, :count).by(0)
    expect(page).to have_content("This email is already taken")
  end

end

feature "User signs in" do

  before(:each) do
    User.create(:email => "test@test.com",
                :password => 'test',
                :password_confirmation => 'test')
  end

  scenario "with correct credentials" do
    visit '/'
    expect(page).not_to have_content("Welcome, test@test.com")
    sign_in('test@test.com', 'test')
    expect(page).to have_content("Welcome, test@test.com")
  end

  scenario "with incorrect credentials" do
    visit '/'
    expect(page).not_to have_content("Welcome, test@test.com")
    sign_in('test@test.com', 'wrong')
    expect(page).not_to have_content("Welcome, test@test.com")
  end

end

feature "User signs out" do

  before (:each) do
    User.create(:email => "test@test.com",
                :password => 'test',
                :password_confirmation => 'test')
  end

  scenario 'while being signed in' do
    sign_in('test@test.com', 'test')
    click_button "Sign out"
    expect(page).to have_content("Goodbye!")
    expect(page).not_to have_content("Welcome, test@test.com")
  end
end

feature 'User forgets password' do

  before(:each) do
    User.create(:email => "test@test.com", :password_token => 'gr8m8')
  end

  scenario 'whilst at sign in' do
    visit '/sessions/new'
    click_on "click here"
    expect(current_path).to eq "/users/reset_password"
  end

  scenario 'whilst submitting email' do
    reset_password('test@test.com')
    expect(page).to have_content "Thank you, test@test.com. We have sent you a reset code. Please check your email"
  end

  scenario 'clicking reset link' do
    visit "users/new_password?token=gr8m8"
    expect(page).to have_content "Please choose a new password."
  end


end


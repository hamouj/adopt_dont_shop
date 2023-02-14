require 'rails_helper'

describe 'applications new page', type: :feature do
  describe 'user story 3' do
    it 'has returns user to application if all form fields are blank' do
      visit 'applications/new'
      
      click_button 'Submit'

      expect(current_path).to eq('/applications/new')
      expect(page).to have_content("Form cannot be blank")
    end  

    it 'has returns user to application if some form fields are blank' do
      visit 'applications/new'
      
      fill_in "Name", with: "Avery"
      fill_in "Street address", with: "123 January"
      fill_in "City", with: "New York"
      click_button 'Submit'

      expect(current_path).to eq('/applications/new')
      expect(page).to have_content("Form cannot be blank")

      visit 'applications/new'
      
      fill_in "Name", with: "Avery"
      click_button 'Submit'

      expect(current_path).to eq('/applications/new')
      expect(page).to have_content("Form cannot be blank")
    end  
  end  

  describe 'user story 2' do
    it 'has a submit button that takes user to application show page' do
      visit '/applications/new'
      
      expect(page).to have_button("Submit")

      fill_in "Name", with: "Avery"
      fill_in "Street address", with: "123 January"
      fill_in "City", with: "New York"
      fill_in "State", with: "NY"
      fill_in "Zip code", with: "11111"

      click_button "Submit"
      @application_1 = Application.last

      expect(current_path).to eq("/applications/#{@application_1.id}")
      expect(page).to have_content("In Progress")
    end  
  end 
end

require 'rails_helper'

describe 'when I visit an admin application show page' do
  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    @applicant_1 = Application.create!(name: 'Jasmine', street_address: '1011 P St.', city: 'Las Vegas', state: 'Nevada', zip_code: '89178', description: "I'm lonely", status: 'Pending')
    @applicant_2 = Application.create!(name: 'Elle', street_address: '2023 Something St.', city: 'Denver', state: 'Colorado', zip_code: '80014', description: nil, status: 'In Progress')

    @pet_1 = @applicant_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false, shelter_id: @shelter_1.id)
    @pet_2 = @applicant_2.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true, shelter_id: @shelter_1.id)
    @pet_3 = @applicant_2.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true, shelter_id: @shelter_3.id)
    @pet_4 = @applicant_2.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true, shelter_id: @shelter_1.id)
  end
  describe 'user story 12' do
    it 'displays a button to approve the application for that specific pet' do
      visit "/admin/applications/#{@applicant_1.id}"

      expect(page).to have_button('Approve Pet')
    end

    it 'when a pet is approved, does not display the approve button and shows the indicator approved' do
      visit "/admin/applications/#{@applicant_1.id}"

      click_button "Approve Pet"

      expect(current_path).to eq("/admin/applications/#{@applicant_1.id}")
      expect(page).to_not have_button("Approve Pet")
      expect(page).to have_content("Pet Approved")
    end

    it 'continues to display an Approve Pet button when only one pet has been approved on an application' do
      visit "/admin/applications/#{@applicant_2.id}"

      click_button "Approve Pet", match: :first

      expect(page).to have_content("Pet Approved")
      expect(page).to have_button("Approve Pet")
    end
  end
end
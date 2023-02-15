require 'rails_helper'

describe 'when I visit an admin application show page' do
  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    @applicant_1 = Application.create!(name: 'Jasmine', street_address: '1011 P St.', city: 'Las Vegas', state: 'Nevada', zip_code: '89178', description: "I'm lonely", status: 'Pending')
    @applicant_2 = Application.create!(name: 'Elle', street_address: '2023 Something St.', city: 'Denver', state: 'Colorado', zip_code: '80014', description: nil, status: 'In Progress')
    @applicant_3 = Application.create!(name: 'Avery', street_address: '123 January', city: 'New York', state: 'New York', zip_code: '12345', description: nil, status: 'In Progress')
    @applicant_4 = Application.create!(name: 'Hailey', street_address: '456 February', city: 'Houston', state: 'Texas', zip_code: '13425', description: "I love all animals.", status: 'Pending')

    @pet_1 = @applicant_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false, shelter_id: @shelter_1.id)
    @pet_2 = @applicant_2.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true, shelter_id: @shelter_1.id)
    @pet_3 = @applicant_2.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true, shelter_id: @shelter_3.id)
    @pet_4 = @applicant_2.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true, shelter_id: @shelter_1.id)

    @applicant_pets = ApplicationPet.create!(application: @applicant_3, pet: @pet_1)
    @applicant_pets2 = ApplicationPet.create!(application: @applicant_4, pet: @pet_2)
    @applicant_pets3 = ApplicationPet.create!(application: @applicant_4, pet: @pet_3)
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

  describe 'user story 13' do
    it 'displays a button to reject the application for that specific pet' do
      visit "/admin/applications/#{@applicant_1.id}"

      expect(page).to have_button('Reject Pet')
    end

    it 'does not display the reject button and shows the indicator rejected' do
      visit "/admin/applications/#{@applicant_1.id}"

      click_button "Reject Pet"

      expect(current_path).to eq("/admin/applications/#{@applicant_1.id}")
      expect(page).to_not have_button("Reject Pet")
      expect(page).to have_content("Pet Rejected")
    end

    it 'continues to display Reject Pet button when only one pet has been rejected on an application' do
      visit "/admin/applications/#{@applicant_2.id}"

      click_button "Reject Pet", match: :first

      expect(page).to have_content("Pet Rejected")
      expect(page).to have_button("Reject Pet")
    end
  end

  describe 'user story 14' do
    it 'displays button to approve or reject the pet for second application' do
      visit "/admin/applications/#{@applicant_1.id}"

      click_button "Reject Pet"

      visit "/admin/applications/#{@applicant_3.id}"
      #applicant 1 and 3 have the same pet
      expect(page).to have_button('Reject Pet')
      expect(page).to have_button('Approve Pet')
    end
  end

  describe 'user story 15' do
    it 'changes the application status to approved when all pets are approved' do
      visit "/admin/applications/#{@applicant_1.id}"

      click_button "Approve Pet"

      expect(page).to have_content("Application Status: Approved")
      expect(current_path).to eq("/admin/applications/#{@applicant_1.id}")
    end

    it 'changes the application status to approved when all pets (multiple) are approved' do
      visit "/admin/applications/#{@applicant_4.id}"

      click_button "Approve Pet", match: :first
      click_button "Approve Pet"

      expect(page).to have_content("Application Status: Approved")
      expect(current_path).to eq("/admin/applications/#{@applicant_4.id}")
    end
  end

  describe 'user story 16' do
    it 'changes the application status to rejected when one or more pets are rejected' do
      visit "/admin/applications/#{@applicant_1.id}"

      click_button "Reject Pet"

      expect(page).to have_content("Application Status: Rejected")
      expect(current_path).to eq("/admin/applications/#{@applicant_1.id}")
    end

    it 'changes the application status to approved when all pets (multiple) are approved' do
      visit "/admin/applications/#{@applicant_4.id}"

      click_button "Reject Pet", match: :first
      click_button "Approve Pet"

      expect(page).to have_content("Application Status: Rejected")
      expect(current_path).to eq("/admin/applications/#{@applicant_4.id}")
    end
  end
end
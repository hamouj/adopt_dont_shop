require 'rails_helper'

describe 'admin index page' do
  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    @applicant_1 = Application.create!(name: 'Jasmine', street_address: '1011 P St.', city: 'Las Vegas', state: 'Nevada', zip_code: '89178', description: "I'm lonely", status: 'Pending')
    @applicant_2 = Application.create!(name: 'Elle', street_address: '2023 Something St.', city: 'Denver', state: 'Colorado', zip_code: '80014', description: nil, status: 'In Progress')

    @pet_1 = @applicant_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false, shelter_id: @shelter_1.id)
    @pet_2 = @applicant_2.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true, shelter_id: @shelter_1.id)
    @pet_3 = @applicant_1.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true, shelter_id: @shelter_3.id)
    @pet_4 = @applicant_2.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true, shelter_id: @shelter_1.id)
  end

  describe 'user story 10' do
    it 'displays all Shelters in the system listed in reverse alphabetical order by name' do
      visit '/admin/shelters'

      expect("RGV animal shelter").to appear_before("Fancy pets of Colorado")
      expect("Fancy pets of Colorado").to appear_before("Aurora shelter")
    end
  end

  describe 'user story 11' do
    it 'has a section for shelters with pending applications and lists the names of the shelters' do
      visit '/admin/shelters'

      within '#pending' do
        expect(page).to have_content("Shelters with Pending Applications")
        expect(page).to have_content("Aurora shelter")
        expect(page).to have_content("Fancy pets of Colorado")
      end
    end
  end
end
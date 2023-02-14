require 'rails_helper'

RSpec.describe ApplicationPet, type: :model do
  describe "relationships" do
    it {should belong_to :application}
    it {should belong_to :pet}
  end

  describe "class methods" do
    before(:each) do
      @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
      @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

      @applicant_1 = Application.create!(name: 'Jasmine', street_address: '1011 P St.', city: 'Las Vegas', state: 'Nevada', zip_code: '89178', description: "I'm lonely", status: 'Pending')
      @applicant_2 = Application.create!(name: 'Elle', street_address: '2023 Something St.', city: 'Denver', state: 'Colorado', zip_code: '80014', description: nil, status: 'In Progress')

      @pet_1 = Pet.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false, shelter_id: @shelter_1.id)
      @pet_2 = Pet.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true, shelter_id: @shelter_1.id)
      @pet_3 = Pet.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true, shelter_id: @shelter_3.id)
      @pet_4 = Pet.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true, shelter_id: @shelter_1.id)

      @application_pet_1 = ApplicationPet.create!(application: @applicant_1, pet: @pet_1)
      @application_pet_2 = ApplicationPet.create!(application: @applicant_1, pet: @pet_3)
      @application_pet_3 = ApplicationPet.create!(application: @applicant_2, pet: @pet_2)
      @application_pet_4 = ApplicationPet.create!(application: @applicant_2, pet: @pet_4)
    end

    describe "#find_record()" do
      it 'returns the specific record based on the application_id and pet_id' do
        expect(ApplicationPet.find_record(@applicant_1.id, @pet_3.id)). to eq(@application_pet_2)
      end
    end
  end
end
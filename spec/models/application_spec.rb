require 'rails_helper'

describe Application, type: :model do
  describe "relationships" do
    it { should have_many :application_pets }
    it { should have_many(:pets).through(:application_pets) }
  end

  describe 'class methods' do
    before(:each) do
      @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
      @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
      @pet_3 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 3, adoptable: false)
      @pet_4 = @shelter_1.pets.create(name: 'Mr Cloud', breed: 'longhair', age: 5, adoptable: false)
      @pet_5 = @shelter_1.pets.create(name: 'Lobster', breed: 'doberman', adoptable: false, age: 3)
  
      @applicant_1 = Application.create!(name: 'Jasmine', street_address: '1011 P St.', city: 'Las Vegas', state: 'Nevada', zip_code: '89178', description: "I'm lonely", status: 'Pending')
      @applicant_2 = Application.create!(name: 'Elle', street_address: '2023 Something St.', city: 'Denver', state: 'Colorado', zip_code: '80014', description: nil, status: 'In Progress')
      
      @application_pet_1 = ApplicationPet.create!(application: @applicant_1, pet: @pet_1, approved: false)
      @application_pet_2 = ApplicationPet.create!(application: @applicant_1, pet: @pet_2, approved: true)
      @application_pet_3 = ApplicationPet.create!(application: @applicant_1, pet: @pet_3)
    end
    describe '#application_pet_approved' do
      it 'returns the approved values for all the pets on an application' do
        expect(@applicant_1.application_pet_approved). to eq([false, true, nil])
      end
    end
  end
end
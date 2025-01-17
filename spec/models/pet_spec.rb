require 'rails_helper'

RSpec.describe Pet, type: :model do
  describe 'relationships' do
    it { should belong_to(:shelter) }
    it {should have_many :application_pets}
    it {should have_many(:applications).through(:application_pets)}
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:age) }
    it { should validate_numericality_of(:age) }
  end

  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 3, adoptable: false)
    @pet_4 = @shelter_1.pets.create(name: 'Mr Cloud', breed: 'longhair', age: 5, adoptable: false)
    @pet_5 = @shelter_1.pets.create(name: 'Lobster', breed: 'doberman', adoptable: false, age: 3)

    @applicant_1 = Application.create!(name: 'Jasmine', street_address: '1011 P St.', city: 'Las Vegas', state: 'Nevada', zip_code: '89178', description: "I'm lonely", status: 'Pending')
    @applicant_2 = Application.create!(name: 'Elle', street_address: '2023 Something St.', city: 'Denver', state: 'Colorado', zip_code: '80014', description: nil, status: 'In Progress')
    
    @application_pet_1 = ApplicationPet.create!(application: @applicant_1, pet: @pet_1)
    @application_pet_2 = ApplicationPet.create!(application: @applicant_2, pet: @pet_1)
  end

  describe 'class methods' do
    describe '#search' do
      it 'returns partial matches' do
        expect(Pet.search("Claw")).to eq([@pet_2])
      end
    end

    describe '#search for user story 8' do
      it 'returns name PARTIALLY matches my search' do
        expect(Pet.search("Cl")).to eq([@pet_2, @pet_4])
        expect(Pet.search("Mr")).to eq([@pet_1, @pet_4])
        expect(Pet.search("Cloud")).to eq([@pet_4])
      end
    end

    describe '#search for user story 9' do
      it 'returns name search is case insensitive' do
        expect(Pet.search("CL")).to eq([@pet_2, @pet_4])
        expect(Pet.search("mR")).to eq([@pet_1, @pet_4])
        expect(Pet.search("LoBsTeR")).to eq([@pet_5])
      end
    end

    describe '#adoptable' do
      it 'returns adoptable pets' do
        expect(Pet.adoptable).to eq([@pet_1, @pet_2])
      end
    end
  end

  describe 'instance methods' do
    describe '.shelter_name' do
      it 'returns the shelter name for the given pet' do
        expect(@pet_3.shelter_name).to eq(@shelter_1.name)
      end
    end

    describe '.find_application_pet()' do
      it 'returns the specific application_pet instance' do
        expect(@pet_1.find_application_pet(@applicant_1.id)).to eq(@application_pet_1)
      end
    end
  end
end

require 'rails_helper'

describe 'applications show page', type: :feature do
  before(:each) do
    @applicant_1 = Application.create!(name: 'Jasmine', street_address: '1011 P St.', city: 'Las Vegas', state: 'Nevada', zip_code: '89178', description: "I'm lonely", status: 'Pending')
    @applicant_2 = Application.create!(name: 'Elle', street_address: '2023 Something St.', city: 'Denver', state: 'Colorado', zip_code: '80014', description: nil, status: 'In Progress')
    
    @shelter = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)

    @pet1 = @applicant_1.pets.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: @shelter.id)
    @pet2 = @applicant_1.pets.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: @shelter.id)
  end

  describe 'user story 1' do
    it 'shows applicant name, address, description, application pets, and application status' do
      visit "applications/#{@applicant_1.id}"

      expect(page).to have_content(@applicant_1.name)
      expect(page).to_not have_content(@applicant_2.name)
      expect(page).to have_content("#{@applicant_1.street_address} #{@applicant_1.city}, #{@applicant_1.state} #{@applicant_1.zip_code}")
      expect(page).to have_content(@applicant_1.description)
      expect(page).to have_content(@pet1.name)
      expect(page).to have_content(@pet2.name)
      expect(page).to have_content(@applicant_1.status)
    end

    it 'has a link to the show page of each pet listed in the application' do
      visit "applications/#{@applicant_1.id}"

      expect(page).to have_link(@pet1.name)
      expect(page).to have_link(@pet2.name)

      click_link "#{@pet1.name}"

      expect(current_path).to eq("/pets/#{@pet1.id}")
    end
  end

  describe 'user story 4' do
    it "has a section to search for a pet on an 'In Progress' application" do
      visit "applications/#{@applicant_2.id}"

      expect(page).to have_content("In Progress")
      expect(page).to_not have_content("#{@pet2.name}")

      within "#pet-section" do
        expect(page).to have_content("Add a Pet to this Application")
        
        fill_in 'search', with: 'Lobster'
        click_on "Submit"

        expect(current_path).to eq("/applications/#{@applicant_2.id}")
        expect(page).to have_content("#{@pet2.name}")
        expect(page).to have_content("#{@pet2.age} years old")
        expect(page).to have_content("Breed: #{@pet2.breed}")
        expect(page).to have_content("Adoptable? #{@pet2.adoptable}")
        expect(page).to have_content("At #{@pet2.shelter_name}")
      end
    end
  end

  describe 'user story 5' do
    it "has a link to add a pet to an 'In Progress' application" do
      visit "applications/#{@applicant_2.id}"
    
      fill_in 'search', with: 'Lobster'
      click_on "Submit"

      expect(page).to have_link("Adopt this Pet")
      
      click_link "Adopt this Pet"

      expect(current_path).to eq("/applications/#{@applicant_2.id}")

      within '#pet-section' do
        expect(page).to have_content("#{@pet2.name}")
      end
    end

    it 'allows you to add multiple pets to an application' do
      visit "applications/#{@applicant_2.id}"
    
      fill_in 'search', with: 'Lobster'
      click_on "Submit"
      
      click_link "Adopt this Pet"

      expect(page).to have_content("Add a Pet to this Application")

      fill_in 'search', with: "Lucille Bald"
      click_on "Submit"

      click_link "Adopt this Pet"

      within '#pet-section' do
        expect(page).to have_content("#{@pet2.name}")
        expect(page).to have_content("#{@pet1.name}")
      end
    end
  end

  describe 'user story 6' do
    it "has a section to add a description and submit the application when a pet is added" do
      visit "applications/#{@applicant_2.id}"
    
      fill_in 'search', with: 'Lobster'
      click_on "Submit"
      click_link "Adopt this Pet"

      expect(page).to have_content("Why would you be a good owner for these pet(s)?")

      fill_in 'description', with: "I am an animal lover and will treat any pet like a family member."
      click_on "Submit Application"

      expect(current_path).to eq("/applications/#{@applicant_2.id}")
    end

    it "changes the application status to 'pending' when I submit my application" do
      visit "applications/#{@applicant_2.id}"
    
      fill_in 'search', with: 'Lobster'
      click_on "Submit"
      click_link "Adopt this Pet"

      fill_in 'description', with: "I am an animal lover and will treat any pet like a family member."
      click_on "Submit Application"

      expect(page).to have_content("Pending")
      expect(page).to have_content("Lobster")
      expect(page).to have_content("I am an animal lover and will treat any pet like a family member.")
      expect(page).to_not have_content("Adopt this Pet")
    end
  end

  describe 'user story 7' do
    it 'does not have a section to submit the application until I add a pet to the application' do
      visit "applications/#{@applicant_2.id}"

      expect(page).to_not have_content(@pet1.name)
      expect(page).to_not have_content(@pet2.name)
      expect(page).to_not have_content("Submit Application")
    end
  end
  
   describe 'user story 8' do
    it "displays search for Pets by name whose name PARTIALLY matches my search" do
      pet3 = @applicant_2.pets.create!(adoptable: true, age: 5, breed: 'lab', name: 'Mr Fluff', shelter_id: @shelter.id)
      visit "applications/#{@applicant_2.id}"
    
      fill_in 'search', with: 'Lob'
      click_on "Submit"

      expect(page).to have_content("#{@pet2.name}")

      visit "applications/#{@applicant_2.id}"
    
      fill_in 'search', with: 'L'
      click_on "Submit"

      expect(page).to have_content("#{@pet2.name}")
      
      visit "applications/#{@applicant_2.id}"
    
      fill_in 'search', with: 'Fluff'
      click_on "Submit"
      
      expect(page).to have_content("#{pet3.name}")
    end
   end

   describe 'user story 9' do
    it 'returns name search is case insensitive' do
      visit "applications/#{@applicant_2.id}"
    
      fill_in 'search', with: 'LoBsTeR'
      click_on "Submit"

      expect(page).to have_content("#{@pet2.name}")
    end
  end
end    


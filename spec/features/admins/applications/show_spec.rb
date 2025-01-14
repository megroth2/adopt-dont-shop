require "rails_helper"

RSpec.describe "Admins Application Show Page" do
  before(:each) do
    @shelter_1 = Shelter.create!(name: "Aurora shelter", city: "Aurora, CO", foster_program: false, rank: 9)
    @shelter_2 = Shelter.create!(name: "RGV animal shelter", city: "Harlingen, TX", foster_program: false, rank: 5)
    @shelter_3 = Shelter.create!(name: "Fancy pets of Colorado", city: "Denver, CO", foster_program: true, rank: 10)
    @turing = Shelter.create!(foster_program: true, name: "Turing", city: "Backend", rank: 3)
    @fsa = Shelter.create!(foster_program: true, name: "Fullstack Academy", city: "Backend", rank: 3)
    @codesmith = Shelter.create!(foster_program: true, name: "Codesmith", city: "Backend", rank: 3)
    @rithm = Shelter.create!(foster_program: true, name: "Rithm School", city: "Backend", rank: 3)
    @hackreactor = Shelter.create!(foster_program: true, name: "Hack Reactor", city: "Backend", rank: 3)

    @pet_1 = @shelter_1.pets.create!(name: "Mr. Pirate", breed: "tuxedo shorthair", age: 5, adoptable: true)
    @pet_2 = @shelter_1.pets.create!(name: "Clawdia", breed: "shorthair", age: 3, adoptable: true)
    @pet_3 = @shelter_3.pets.create!(name: "Lucille Bald", breed: "sphynx", age: 8, adoptable: true)
    @pet_4 = @shelter_1.pets.create!(name: "Ann", breed: "ragdoll", age: 5, adoptable: true)

    @application_1 = Application.create!(name: "John", street_address: "1234 ABC Lane", city: "Turing", state: "Backend", zipcode: "54321", description: "I love cats")
    @application_2 = Application.create!(name: "Jake", street_address: "1234 ABC Lane", city: "Turing", state: "Backend", zipcode: "54321", description: "I love dogs", status: "Pending")
    @application_3 = Application.create!(name: "Jerry", street_address: "1234 ABC Lane", city: "Turing", state: "Backend", zipcode: "54321", description: "I love hamsters", status: "Pending")

    @application_pet_1 = ApplicationPet.create!(application_id: @application_2.id, pet_id: @pet_1.id)
    @application_pet_2 = ApplicationPet.create!(application_id: @application_3.id, pet_id: @pet_3.id)
    @application_pet_2 = ApplicationPet.create!(application_id: @application_2.id, pet_id: @pet_3.id)
    @application_pet_2 = ApplicationPet.create!(application_id: @application_3.id, pet_id: @pet_4.id)
  end

  it "has a button to approve an application for every pet that the application pet is for" do
    # User Story 12
    visit "/admin/applications/#{@application_2.id}"
    within "#pet-#{@pet_1.id}" do
      expect(page).to have_content("Mr. Pirate")
      expect(page).to have_button("Approve")
      click_button("Approve")

      expect(page.current_path).to eq("/admin/applications/#{@application_2.id}")
      expect(page).to have_content("Pet Approved")
    end
  end

  describe "13. Rejecting a Pet for Adoption" do
    it "has a button to reject the application for a pet" do
      visit "/admin/applications/#{@application_2.id}"
      within "#pet-#{@pet_1.id}" do
        expect(page).to have_button("Reject")
      end
    end

    it "takes me back to the admins/show page and does not show approval or rejection button when I click on reject" do
      visit "/admin/applications/#{@application_2.id}"
      within "#pet-#{@pet_1.id}" do
        click_button("Reject")

        expect(page.current_path).to eq("/admin/applications/#{@application_2.id}")
        expect(page.has_button?).to be false
        expect(page).to have_content("Pet Rejected")
      end
    end
  end

  describe "14. Approved/Rejected Pets on one Application do not affect other Applications" do
    it "makes sure that approving one pet for an application does not affect another application that also has the same pet" do
    visit "/admin/applications/#{@application_2.id}"
      within "#pet-#{@pet_3.id}" do
        expect(page).to have_content("Lucille Bald")
        expect(page).to have_button("Approve")


        click_button("Approve")
        expect(page.current_path).to eq("/admin/applications/#{@application_2.id}")
        expect(page).to have_content("Pet Approved")
      end


    visit "/admin/applications/#{@application_3.id}"
      within "#pet-#{@pet_3.id}" do
        expect(page).to have_content("Lucille Bald")
        expect(page).to have_no_content("Pet Approved")
      end
    end
  end

  describe "15. All Pets Accepted on an Application - Completed Applications" do
    it "changes application status to 'approved' when all pets have been approved" do
      visit "/admin/applications/#{@application_2.id}"
        within "#pet-#{@pet_3.id}" do
          click_button("Approve")
        end

        within "#pet-#{@pet_1.id}" do
          click_button("Approve")
        end
        expect(page.current_path).to eq("/admin/applications/#{@application_2.id}")
        expect(page).to have_content("Approved")
    end
  end

  describe "16. One or More Pets Rejected on an Application" do
    it "takes me back to 'admin/applications/:id' when I've rejected one or more pet and other pets have been approved" do
      visit "/admin/applications/#{@application_2.id}"
      within "#pet-#{@pet_3.id}" do
        click_button("Approve")
      end
      within "#pet-#{@pet_1.id}" do
        click_button("Reject")
      end

      expect(page.current_path).to eq("/admin/applications/#{@application_2.id}")
      expect(page).to have_content("Pet Application For #{@application_2.name} Is Rejected")
    end
  end

  describe "17. Application Approval makes Pets not adoptable" do
    it "can change the status of a pet from `adoptable` to `not adoptable` when ALL pets are approved" do
      #status of pet does not change until ALL pets are approved
      #use APPLICATIONS not APPLICATION_PETS
      
      visit "pets/#{@pet_3.id}"
      expect(page).to have_content("Adoptable: true")

      visit "/admin/applications/#{@application_2.id}"

      within "#pet-#{@pet_3.id}" do
        click_button("Approve")
      end

      visit "pets/#{@pet_3.id}"

      expect(page).to have_no_content("Adoptable: true")

      visit "/admin/applications/#{@application_2.id}"

      within "#pet-#{@pet_1.id}" do
        click_button("Approve")
      end

      visit "pets/#{@pet_1.id}"

      expect(page).to have_no_content("Adoptable: true")
    end
  end

  describe "18. Pets can only have one approved application on them at any time" do
    it "will not show a button to approve a pet if it has already been approved on another application" do
      visit "/admin/applications/#{@application_2.id}"

      within "#pet-#{@pet_3.id}" do
        expect(page).to have_button("Approve")
        click_button("Approve")
        expect(page).to have_content("Pet Approved")
      end
      within "#pet-#{@pet_1.id}" do
        expect(page).to have_button("Approve")
      end
      visit "/pets/#{@pet_3.id}"
      expect(page).to have_content("Adoptable: false")

      visit "/admin/applications/#{@application_3.id}"
      within "#pet-#{@pet_3.id}" do
        expect(page).to have_no_button("Approve")
        expect(page).to have_content("This pet has already been approved for adoption")
        expect(page).to have_button("Reject")
      end
    end
  end

end

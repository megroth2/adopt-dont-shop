require "rails_helper"

RSpec.describe ApplicationPet, type: :model do
  before(:each) do
    @application_1 = Application.create(name: "John", street_address: "1234 ABC Lane", city: "Turing", state: "Backend", zipcode: "54321", description: "I love animals")

    @shelter = Shelter.create(foster_program: true, name: "Turing", city: "Backend", rank: 3)

    @dog = @shelter.pets.create(adoptable: true, age: 4, breed: "Golden Retriever", name: "Dog")
    @cat = @shelter.pets.create(adoptable: true, age: 1, breed: "Tabby", name: "cat")

    @application_pet_1 = ApplicationPet.create(application_id: @application_1.id, pet_id: @dog.id)
    @application_pet_2 = ApplicationPet.create(application_id: @application_1.id, pet_id: @cat.id)
  end

  describe "associations" do
    it{should belong_to(:application)}
    it{should belong_to(:pet)}
  end

  describe "#set_application_approved" do
    it "will change the state of @application_approved to true" do
      expect(@application_pet_1.application_approved).to eq nil

      @application_pet_1.set_application_approved

      expect(@application_pet_1.application_approved).to eq true
    end
  end

  describe "#set_application_denied" do
    it "will change the state of @application_approved to true" do
      expect(@application_pet_1.application_approved).to eq nil

      @application_pet_1.set_application_denied

      expect(@application_pet_1.application_approved).to eq false
    end
  end

  describe "#approve_or_deny" do
    xit "" do
      # placeholder
    end
  end
  
end

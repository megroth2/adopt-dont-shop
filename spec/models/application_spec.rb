require "rails_helper"

RSpec.describe Application, type: :model do
  before(:each) do
    @application_1 = Application.create(name: "John", street_address: "1234 ABC Lane", city: "Turing", state: "Backend", zipcode: "54321", description: "I love animals")

    @shelter = Shelter.create(foster_program: true, name: "Turing", city: "Backend", rank: 3)

    @dog = @shelter.pets.create(adoptable: true, age: 4, breed: "Golden Retriever", name: "Dog")
    @cat = @shelter.pets.create(adoptable: true, age: 1, breed: "Tabby", name: "cat")

    @application_pet_1 = ApplicationPet.create(application_id: @application_1.id, pet_id: @dog.id)
    @application_pet_2 = ApplicationPet.create(application_id: @application_1.id, pet_id: @cat.id)
  end

  describe "validations" do
    it {should validate_presence_of :name}
    it {should validate_presence_of :street_address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zipcode}
    it {should validate_numericality_of :zipcode}
    it {should validate_presence_of :description}
  end

  describe "assocations" do
    it {should have_many(:application_pets)}
  end

  describe "#full_address" do
    it "will concatenate address fields" do
      address = ("1234 ABC Lane Turing, Backend 54321")

      expect(@application_1.full_address).to eq(address)
    end
  end

  describe "#list_of_pets" do
    it "will list pets that the applicant wants to adopt" do

      expect(@application_1.list_of_pets).to eq([@dog, @cat])
    end
  end

  describe "#set_status_in_progress" do
    it "can set status to in progress" do
      @application_1.set_status_in_progress

      expect(@application_1.status).to eq("In Progress")
    end
  end

  describe "#find_pet()" do
    it "can find pets with a matching name" do

      expect(@application_1.find_pet("Dog")).to eq([@dog])
    end

    it "can find pets with a PARTIALLY matching name" do

      expect(@application_1.find_pet("dog")).to eq([@dog])
      expect(@application_1.find_pet("do")).to eq([@dog])
    end
  end

  describe "#added_pets?" do
    it "will check if there are any pets in #list_of_pets and return true or false" do
      expect(@application_1.added_pets?).to eq true

      application_2 = Application.create(name: "John", street_address: "1234 ABC Lane", city: "Turing", state: "Backend", zipcode: "54321", description: "I love animals")

      expect(application_2.added_pets?).to eq false
    end
  end

  describe "#all_pets_approved?" do
    xit "" do
      # placeholder
    end
  end

  describe "#status_of_application_pet" do
    xit "" do
      # placeholder
    end
  end

end

  # describe "#set_status_pending" do
  #   it "can set status to pending" do
  #     @application_1.good_owner_comments = "We bonded at the shelter."
  #     @application_1.set_status_pending

  #     expect(@application_1.status).to eq("Pending")
  #   end
  # end

  # xdescribe "#has_good_owner_comments?" do
  #   it "has good owner comments" do
  #     @application_1.good_owner_comments = "We bonded at the shelter."

  #     expect(@application_1.has_good_owner_comments?).to eq(true)
  #   end

  #   it "does not have good owner comments" do
  #     @application_1.good_owner_comments == nil

  #     expect(@application_1.has_good_owner_comments?).to eq(false)
  #   end
  # end

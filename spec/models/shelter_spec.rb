require "rails_helper"

RSpec.describe Shelter, type: :model do
  describe "relationships" do
    it{should have_many(:pets)}
    # do we need to test the "dependent: destroy" part here too or is that tested elsewhere?
  end

  describe "validations" do
    it{should validate_presence_of(:name)}
    it{should validate_presence_of(:city)}
    it{should validate_presence_of(:rank)}
    it{should validate_numericality_of(:rank)}
  end

  before(:each) do
    @shelter_1 = Shelter.create(name: "Aurora shelter", city: "Aurora, CO", foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: "RGV animal shelter", city: "Harlingen, TX", foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: "Fancy pets of Colorado", city: "Denver, CO", foster_program: true, rank: 10)


    @pet_1 = @shelter_1.pets.create(name: "Mr. Pirate", breed: "tuxedo shorthair", age: 5, adoptable: false)
    @pet_2 = @shelter_1.pets.create(name: "Clawdia", breed: "shorthair", age: 3, adoptable: true)
    @pet_3 = @shelter_3.pets.create(name: "Lucille Bald", breed: "sphynx", age: 8, adoptable: true)
    @pet_4 = @shelter_1.pets.create(name: "Ann", breed: "ragdoll", age: 5, adoptable: true)

    @application_1 = Application.create(name: "John", street_address: "1234 ABC Lane", city: "Turing", state: "Backend", zipcode: "54321", description: "I love cats")
    @application_2 = Application.create(name: "Jake", street_address: "1234 ABC Lane", city: "Turing", state: "Backend", zipcode: "54321", description: "I love dogs", status: "Pending")
    @application_3 = Application.create(name: "Jerry", street_address: "1234 ABC Lane", city: "Turing", state: "Backend", zipcode: "54321", description: "I love hamsters", status: "Pending")

    @application_pet_1 = ApplicationPet.create(application_id: @application_2.id, pet_id: @pet_1.id)
    @application_pet_2 = ApplicationPet.create(application_id: @application_3.id, pet_id: @pet_3.id)
  end

  describe "class methods" do
    # I couldn't find this method in the pet.rb model - where is this test coming from?
    describe "#search" do
      it "returns partial matches" do
        expect(Shelter.search("Fancy")).to eq([@shelter_3])
      end
    end

    describe "#order_by_recently_created" do
      it "returns shelters with the most recently created first" do
        expect(Shelter.order_by_recently_created).to eq([@shelter_3, @shelter_2, @shelter_1])
      end
    end

    describe "#order_by_number_of_pets" do
      it "orders the shelters by number of pets they have, descending" do
        expect(Shelter.order_by_number_of_pets).to eq([@shelter_1, @shelter_3, @shelter_2])
      end
    end

    describe "#order_by_reverse_alphabetically" do
      it "returns all Shelters listed in reverse alphabetical order by name" do
        @turing = Shelter.create(foster_program: true, name: "Turing", city: "Backend", rank: 3)
        @fsa = Shelter.create(foster_program: true, name: "Fullstack Academy", city: "Backend", rank: 3)
        @codesmith = Shelter.create(foster_program: true, name: "Codesmith", city: "Backend", rank: 3)
        @rithm = Shelter.create(foster_program: true, name: "Rithm School", city: "Backend", rank: 3)
        @hackreactor = Shelter.create(foster_program: true, name: "Hack Reactor", city: "Backend", rank: 3)

        @shelters = Shelter.order_by_reverse_alphabetically
        first = @shelters.first
        last = @shelters.last

        expect(@shelters).to eq [@turing, @rithm, @shelter_2, @hackreactor, @fsa, @shelter_3, @codesmith, @shelter_1]
        expect(first.name).to eq("Turing")
        expect(last.name).to eq("Aurora shelter")
      end
    end

    describe "#pending_applications" do
      it "returns a list of shelters that have pending applications" do

        expect(Shelter.pending_applications).to eq ([@shelter_1, @shelter_3])
      end
    end
  end

  describe "instance methods" do
    describe "#pet_count" do
      it "returns the number of pets at the given shelter" do
        expect(@shelter_1.pet_count).to eq(3)
      end
    end

    describe "#adoptable_pets" do
      it "only returns pets that are adoptable" do
        expect(@shelter_1.adoptable_pets).to eq([@pet_2, @pet_4])
      end
    end

    describe "#alphabetical_pets" do
      it "returns pets associated with the given shelter in alphabetical name order" do
        expect(@shelter_1.alphabetical_pets).to eq([@pet_4, @pet_2])
      end
    end

    describe "#shelter_pets_filtered_by_age" do
      it "filters the shelter pets based on given params" do
        expect(@shelter_1.shelter_pets_filtered_by_age(5)).to eq([@pet_4])
      end
    end
  end

end

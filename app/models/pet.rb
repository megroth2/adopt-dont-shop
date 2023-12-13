class Pet < ApplicationRecord
  validates :name, presence: true
  validates :age, presence: true, numericality: true
  belongs_to :shelter
  has_many :application_pets
  has_many :applications, through: :application_pets

  def shelter_name
    shelter.name
  end

  def self.set_adoptable_false(id)
    pet = find_pet(id)
    pet.adoptable = false
    pet.save
  end

  def self.find_pet(id)
    find(id)
  end

  def self.adoptable
    where(adoptable: true)
  end

  def application_pet_approved(id)
    ApplicationPet.where(pet_id: self.id, application_id: id).pluck(:application_approved).first
  end

  def already_approved?
    adoptable ? false : true
  end
end

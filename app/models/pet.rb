class Pet < ApplicationRecord
  validates :name, presence: true
  validates :age, presence: true, numericality: true
  belongs_to :shelter
  has_many :application_pets

  def shelter_name
    shelter.name
  end

  def self.adoptable
    where(adoptable: true)
  end

  def application_pet_approved(application_id) # I played around with this in pry to try to understand and it doesn't appear to be working?
    ApplicationPet.where(pet_id: self.id, application_id: application_id).pluck(:application_approved).first
  end
end

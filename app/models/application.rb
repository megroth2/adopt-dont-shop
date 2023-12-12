class Application < ApplicationRecord
  validates :name, presence: true
  validates :street_address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zipcode, presence: true, numericality: true
  validates :description, presence: true
  has_many :application_pets

  def full_address
    street_address << " " << city << ", " << state << " " << zipcode
  end

  def list_of_pets
    pet_ids = application_pets.where("application_id = ?", self.id).pluck(:pet_id)
    Pet.where(id: pet_ids)
  end

  def set_status_in_progress
    self.status = "In Progress"
    self.save
  end

  def find_pet(name)
    Pet.where("name ILIKE ?", "%#{name}%")
  end

  def added_pets?
    list_of_pets.present?
  end

  def all_pets_approved? # Is this checking for all pets approved or just one? It seems like it limits it to just one. Want to take a closer look so I can understand whats going on
    status_of_application_pet.uniq.count == 1 && status_of_application_pet.first == true
  end

  def status_of_application_pet # as currently written this will return true or false - is that expected? If so, can we rename it per ruby convention (with a ?)
    ApplicationPet.where(application_id: self.id).pluck(:application_approved)
  end
end

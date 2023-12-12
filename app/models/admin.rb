class Admin < ApplicationRecord

  def self.check_for_application_pet_approval(application_id, pet_id)
    ApplicationPet.select(:application_approved).where(application_id: application_id, pet_id: pet_id).pluck(:application_approved).first
  end

  def self.application(id)
    Application.find(id)
  end

  def self.shelters
    Shelter.order_by_reverse_alphabetically
  end

  def self.approve_or_deny_application_pet(pet_id, application_id, filter)
    application_pet_id = ApplicationPet.where(pet_id: pet_id, application_id: application_id).pluck(:id).first
    application_pet = ApplicationPet.find(application_pet_id)
    application_pet.approve_or_deny(filter)
  end
end

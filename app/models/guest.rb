class Guest < ApplicationRecord
  has_many :reservations, through: :reservation_guests
end

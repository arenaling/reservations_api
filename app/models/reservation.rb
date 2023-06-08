class Reservation < ApplicationRecord
  has_many :reservation_guests
  has_many :guests, through: :reservation_guests
end

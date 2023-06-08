class CreateReservationGuests < ActiveRecord::Migration[7.0]
  def change
    create_table :reservation_guests do |t|
      t.integer :reservation_id
      t.integer :guest_id

      t.timestamps
    end
  end
end

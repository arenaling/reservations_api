require "instances/payload_type"

class ReservationsController < ApplicationController
  protect_from_forgery with: :null_session,
    if: Proc.new { |c| c.request.format =~ %r{application/json} }

  def create
    reservation_params = params
    
    payload_processor = identify_payload_type(reservation_params)

    if payload_processor
      parsed_payload = payload_processor.parse_payload
      reservation_data = parsed_payload[0]
      guests_data = parsed_payload[1]

      if(
        reservation_data[:reservation_code].nil? ||
        (guests_data.length == 0 || guests_data[0][:email].nil?)
      )
        render json: { error: "Reservation code and guest's email needed." }, status: :unprocessable_entity
        return
      end

      reservation = Reservation.find_or_create_by(reservation_code: reservation_data[:reservation_code])
      reservation.update(reservation_data)

      guests_data.each do |guest_data|
        guest = Guest.find_or_create_by(email: guest_data[:email])
        guest.update(guest_data)
      end

      render json: { message: 'Reservation created successfully.' }, status: :created
    else
      render json: { error: 'Invalid payload type.' }, status: :unprocessable_entity
    end
  end

  private
  def identify_payload_type(payload)
    payload_types_directory = Rails.root.join('lib', 'payload_types')
    payload_type_files = Dir.glob("#{payload_types_directory}/*.rb")


    payload_types = payload_type_files.map do |file|
      require_dependency file
      class_name = File.basename(file, '.rb').camelize
      payload_type_class = Object.const_get(class_name)

      if payload_type_class < PayloadType
        payload_type_class.new(payload)
      else
        nil
      end
    end.compact

    similarity_counts = payload_types.map { |payload_type| [payload_type, payload_type.identify_payload] }
    similarity_counts.sort_by! { |_, count| -count }

    most_similar_payload_type = similarity_counts.first
    return most_similar_payload_type[0] if most_similar_payload_type[1] > 0

    return nil
  end
end

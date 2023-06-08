require "instances/payload_type"

class PayloadType1 < PayloadType
  def initialize(payload)
    super(payload)
  end
  
  def identify_payload
    similar_attributes = 0
    
    similar_attributes += 1 if @payload.key?(:reservation_code) 
    similar_attributes += 1 if @payload.key?(:start_date)
    similar_attributes += 1 if @payload.key?(:end_date)
    similar_attributes += 1 if @payload.key?(:nights)
    similar_attributes += 1 if @payload.key?(:guests)
    similar_attributes += 1 if @payload.key?(:adults)
    similar_attributes += 1 if @payload.key?(:children)
    similar_attributes += 1 if @payload.key?(:infants)
    similar_attributes += 1 if @payload.key?(:status)
    similar_attributes += 1 if @payload.key?(:currency)
    similar_attributes += 1 if @payload.key?(:payout_price)
    similar_attributes += 1 if @payload.key?(:security_price)
    similar_attributes += 1 if @payload.key?(:total_price)
  
    return similar_attributes
  end
  
  def payload_type_name
    return 'source number 1'
  end
  
  def parse_payload
    reservation_data = {
      reservation_code: @payload[:reservation_code],
      start_date: @payload[:start_date],
      end_date: @payload[:end_date],
      nights: @payload[:nights],
      total_guests: @payload[:guests],
      adults: @payload[:adults],
      children: @payload[:children],
      infants: @payload[:infants],
      status: @payload[:status],
      currency: @payload[:currency],
      payout_price: @payload[:payout_price],
      security_price: @payload[:security_price],
      total_price: @payload[:total_price]
    }
   
    guest_data = []
    if @payload[:guest]
      guest_data.push({ 
        first_name: @payload[:guest][:first_name], 
        last_name: @payload[:guest][:last_name],
        phone: @payload[:guest][:phone],
        email: @payload[:guest][:email]
      })
    end
  
    [reservation_data, guest_data]
  end
end
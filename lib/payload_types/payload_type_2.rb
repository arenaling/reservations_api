require 'instances/payload_type'

class PayloadType2 < PayloadType
  def initialize(payload)
    super(payload)
  end
  
  def identify_payload
    similar_attributes = 0
    
    if @payload[:reservation]
      similar_attributes += 1 if @payload[:reservation].key?(:code) 
      similar_attributes += 1 if @payload[:reservation].key?(:start_date)
      similar_attributes += 1 if @payload[:reservation].key?(:end_date)
      similar_attributes += 1 if @payload[:reservation].key?(:nights)
      similar_attributes += 1 if @payload[:reservation].key?(:number_of_guests)
      similar_attributes += 1 if @payload[:reservation].key?(:guest_details)
      similar_attributes += 1 if @payload[:reservation].key?(:status_type)
      similar_attributes += 1 if @payload[:reservation].key?(:host_currency)
      similar_attributes += 1 if @payload[:reservation].key?(:expected_payout_amount)
      similar_attributes += 1 if @payload[:reservation].key?(:listing_security_price_accurate)
      similar_attributes += 1 if @payload[:reservation].key?(:total_paid_amount_accurate)
      
      if @payload[:reservation][:guest_details]
        similar_attributes += 1 if @payload[:reservation][:guest_details].key?(:number_of_adults) 
        similar_attributes += 1 if @payload[:reservation][:guest_details].key?(:number_of_children)
        similar_attributes += 1 if @payload[:reservation][:guest_details].key?(:number_of_infants)
      end
    end
    
    return similar_attributes
  end
  
  def payload_type_name
    return 'source number 2'
  end
  
  def parse_payload
    reservation_data = {
      reservation_code: @payload[:reservation][:code],
      start_date: @payload[:reservation][:start_date],
      end_date: @payload[:reservation][:end_date],
      nights: @payload[:reservation][:nights],
      total_guests: @payload[:reservation][:number_of_guests],
      status: @payload[:reservation][:status_type],
      currency: @payload[:reservation][:host_currency],
      payout_price: @payload[:reservation][:expected_payout_amount],
      security_price: @payload[:reservation][:listing_security_price_accurate],
      total_price: @payload[:reservation][:total_paid_amount_accurate]
    }
    
    if @payload[:reservation][:guest_details]
      reservation_data[:adults] = @payload[:reservation][:guest_details][:number_of_adults]
      reservation_data[:children] = @payload[:reservation][:guest_details][:number_of_children]
      reservation_data[:infants] = @payload[:reservation][:guest_details][:number_of_infants]
    end
  
    guest_data = [{
      first_name: @payload[:reservation][:guest_first_name],
      last_name: @payload[:reservation][:guest_last_name],
      phone: @payload[:reservation][:guest_phone_numbers].first,
      email: @payload[:reservation][:guest_email]
    }]
    
    [reservation_data, guest_data]
  end
end
class PayloadType
  def initialize(payload)
    @payload = payload
  end
  
  def identify_payload
    # Implement this method in the subclasses
  end
  
  def payload_type_name
  end
  
  def get_payload
    @payload
  end
  
  def parse_payload
  end
end

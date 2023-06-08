require 'swagger_helper'

describe 'Reservation API' do
  path '/reservations' do
    post 'Create or update reservation' do
      tags 'Reservation'
      consumes 'application/json'
      parameter name: :reservation, in: :body, schema: {
          type: :object,
          properties: {
            "reservation_code": { type: :string },
            "start_date": { type: :string },
            "end_date": { type: :string },
            "nights": { type: :integer },
            "guests": { type: :integer },
            "adults": { type: :integer },
            "children": { type: :integer },
            "infants": { type: :integer },
            "status": { type: :string },
            "guest": {
              "first_name": { type: :string },
              "last_name": { type: :string },
              "phone": { type: :string },
              "email": { type: :string }
            },
            "currency": { type: :string },
            "payout_price": { type: :integer },
            "security_price": { type: :integer },
            "total_price": { type: :integer }
          }
        }
  
      response '201', 'Reservation created successfully.' do
        run_test!
      end
    
      response '422', 'Invalid payload type.' do
        run_test!
      end
    end
  end
end
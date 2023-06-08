# spec/requests/reservations_spec.rb
require 'rails_helper'

RSpec.describe 'Reservations API', type: :request do
  describe 'POST /reservations' do
    context 'with valid payload #1' do
      let(:payload) do
        {
          reservation_code: 'YYY12345678',
          start_date: '2021-04-14',
          end_date: '2021-04-18',
          nights: 4,
          guests: 4,
          adults: 2,
          children: 2,
          infants: 0,
          status: 'accepted',
          guest: {
            first_name: 'Wayne',
            last_name: 'Woodbridge',
            phone: '639123456789',
            email: 'wayne_woodbridge@bnb.com'
          },
          currency: 'AUD',
          payout_price: '4200.00',
          security_price: '500',
          total_price: '4700.00'
        }
      end

      it 'creates a new reservation' do
        expect {
          post '/reservations', params: payload.to_json, headers: { 'Content-Type' => 'application/json' }
        }.to change(Reservation, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(response_body['reservation_code']).to eq(payload[:reservation_code])

        # Retrieve the created reservation from the database
        reservation = Reservation.find_by(reservation_code: payload[:reservation_code])
        expect(reservation).to be_present
        expect(reservation.start_date).to eq(Date.parse(payload[:start_date]))
        expect(reservation.end_date).to eq(Date.parse(payload[:end_date]))
        # Add more assertions to validate other attributes as needed
      end
    end

    # ... other test cases

    context 'with invalid payload' do
      let(:payload) do
        {
          # Invalid payload data
        }
      end

      it 'returns a validation error' do
        post '/reservations', params: payload.to_json, headers: { 'Content-Type' => 'application/json' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to include('Invalid payload type.')
        # Add more assertions as needed
      end
    end
  end
end

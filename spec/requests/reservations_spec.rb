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

      it 'creates a new reservation #1' do
        expect {
          post '/reservations', params: payload.to_json, headers: { 'Content-Type' => 'application/json' }
        }.to change(Reservation, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['message']).to eq("Reservation created successfully.")

        # Retrieve the created reservation from the database
        reservation = Reservation.find_by(reservation_code: payload[:reservation_code])
        expect(reservation).to be_present
        guest = Guest.find_by(email: payload[:guest][:email])
        expect(guest).to be_present
      end
    end

    context 'with valid payload #2' do
        let(:payload) do
          {
              "reservation": {
                "code": "XXX12345678",
                "start_date": "2021-03-12",
                "end_date": "2021-03-16",
                "expected_payout_amount": "3800.00",
                "guest_details": {
                  "localized_description": "4 guests",
                  "number_of_adults": 2,
                  "number_of_children": 2,
                  "number_of_infants": 0
                },
                "guest_email": "wayne_woodbridge@bnb.com",
                "guest_first_name": "Wayne",
                "guest_last_name": "Woodbridge",
                "guest_phone_numbers": [
                  "639123456789",
                  "639123456789"
                ],
                "listing_security_price_accurate": "500.00",
                "host_currency": "AUD",
                "nights": 4,
                "number_of_guests": 4,
                "status_type": "accepted",
                "total_paid_amount_accurate": "4300.00"
              }
          }
        end

        it 'creates a new reservation #2' do
          expect {
          post '/reservations', params: payload.to_json, headers: { 'Content-Type' => 'application/json' }
        }.to change(Reservation, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['message']).to eq("Reservation created successfully.")

        # Retrieve the created reservation from the database
        reservation = Reservation.find_by(reservation_code: payload[:reservation][:code])
        expect(reservation).to be_present
        guest = Guest.find_by(email: payload[:reservation][:guest_email])
        expect(guest).to be_present
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

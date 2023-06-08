# API Endpoint for Reservations

This project implements an API endpoint using Ruby on Rails to handle reservations from another services. It supports two different payload formats but also capable to add new payload format in the future, and provides the ability to create and update reservations. This project is using SQLite so there is no need to extra preparation for database.

## Logical Explanation

The API endpoint allows clients to send reservation data in any different payload formats, by creating new class in directory /lib/payload_types/ that inherit PayloadType class and implement logic in methods. It parses the payload and saves the data to a Reservation model that has many to many to a Guest model. Mandatory attributes that must be exist is reservation code and guest's email. These 2 attributes make them as unique key in Reservation and Guest table.

The API endpoint can handle changes to the reservation, such as updating the status, check-in/out dates, number of guests, and more.

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/arenaling/reservations_api.git
   ```

2. Navigate to the project directory:

   ```bash
   cd reservation-api
   ```

3. Install the required dependencies:

   ```bash
   bundle install
   ```

4. Set up the database:

   ```bash
   rails db:setup
   ```

5. Start the Rails server:

   ```bash
   rails server
   ```

   The API endpoint will be accessible at `http://localhost:3000`.

## URL

For reservation API :
```
http://localhost:3000/reservations
```

For reservation API Doc by Swagger found in here :
```
http://localhost:3000/api-docs/index.html
```


## Testing

The project includes unit tests using the RSpec testing framework. To run the tests, execute the following command:

```bash
rspec
```

The test suite includes tests for different payload scenarios, including 2 valid payloads and invalid payloads. It verifies the creation and updating of reservations and performs validations to ensure the correct behavior of the API endpoint.

And also when rails server is alive, it can be tested with Postman, by specifying its target to http://localhost:3000/reservations , method post, and define body param as raw JSON and fill it one of these example:

#1

```json
{
"reservation_code": "YYY12345678",
"start_date": "2021-04-14",
"end_date": "2021-04-18",
"nights": 4,
"guests": 4,
"adults": 2,
"children": 2,
"infants": 0,
"status": "accepted",
"guest": {
"first_name": "Wayne",
"last_name": "Woodbridge",
"phone": "639123456789",
"email": "wayne_woodbridge@bnb.com"
},
"currency": "AUD",
"payout_price": "4200.00",
"security_price": "500",
"total_price": "4700.00"
}
```
#2

```json
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
```

## Deploying

To deploy the application to a production environment, follow these steps:

1. Configure the production database settings in `config/database.yml`.

2. Set up the necessary environment variables, such as the database credentials and any required API keys.

3. Start the Rails server in production mode:

   ```bash
   RAILS_ENV=production rails server
   ```

   You may choose to use a production web server like Nginx or Apache to serve the application.
4. Configure a domain or subdomain to point to the server's IP address or hostname.

   Note: Make sure to set up SSL/TLS encryption for secure communication if necessary.


   ## Thank you!

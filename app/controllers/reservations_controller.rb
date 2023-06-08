class ReservationsController < ApplicationController
  protect_from_forgery with: :null_session,
    if: Proc.new { |c| c.request.format =~ %r{application/json} }
  def create
    reservation_params = params
    
  end
end

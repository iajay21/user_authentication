class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/json' }
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
end

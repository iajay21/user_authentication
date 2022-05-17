class Api::ApplicationController < ApplicationController
  include Api::SessionHelper
  skip_before_action :authenticate_user!
  before_action :authenticate_user_from_token
  respond_to :json
end
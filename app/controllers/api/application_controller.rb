class Api::ApplicationController < ApplicationController
  include Api::SessionHelper
  skip_before_action :authenticate_user!
  before_action :authenticate_user_from_token
  respond_to :json

  # Swagger::Docs::Generator::set_real_methods
  # include Swagger::Docs::ImpotentMethods
  class << self
    Swagger::Docs::Generator::set_real_methods

    def inherited(subclass)
      super
      subclass.class_eval do
        setup_basic_api_documentation
      end
    end

    private
    
    def setup_basic_api_documentation
      [:index, :show, :create, :update, :delete].each do |api_action|
        swagger_api api_action do
          param :header, 'Authorization', :string, :required, 'Authentication Token'
        end
      end
    end
  end
end
# Swagger::Docs::Config.register_apis({
#   "1.0" => {
#     # the extension used for the API
#     :api_extension_type => :json,
#     # the output location where your .json files are written to
#     :api_file_path => "public/apidocs",
#     # the URL base path to your API
#     :base_path => "http://localhost:3000",
#     # if you want to delete all .json files at each generation
#     :clean_directory => true,
#     # Ability to setup base controller for each api version. Api::V1::SomeController for example.
#     :parent_controller => Api::ApplicationController,
#     # add custom attributes to api-docs
#     :attributes => {
#       :info => {
#         "title" => "User Apis",
#         "description" => "Rails API documention with Swagger UI.",
#         "termsOfServiceUrl" => "",
#         "contact" => ""
#        }
#      }
#   }
# })

class Swagger::Docs::Config
  def self.transform_path(path, api_version)
    # Make a distinction between the APIs and API documentation paths.
    "apidocs/#{path}"
  end
end

Swagger::Docs::Config.register_apis({
  '1.0' => {
    :clean_directory => true,
    :api_extension_type => :json,
    controller_base_path: '',
    api_file_path: 'public/apidocs',
    base_path: 'http://localhost:3000',
    clean_directory: true
  }
})
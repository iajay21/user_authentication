json.data do |json|
  json.user_id api_current_user.id
  json.email api_current_user.email
  json.name api_current_user.name
  json.last_signin api_current_user.current_sign_in_at.to_i
  json.signin_count api_current_user.sign_in_count
  json.created_at api_current_user.created_at.to_i
  json.updated_at api_current_user.updated_at.to_i   
end
json.message "success"
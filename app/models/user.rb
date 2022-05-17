class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable  

  validates :name, presence: true

  has_one_attached :avatar
  validates :avatar, attached: false, content_type: ['image/png', 'image/jpeg', 'image/jpg'], dimension: { width: 200, height: 200 }
  # u.image.attach(io: File.open('/home/davejc99/Pictures/Wallpapers/638022.jpg'), filename: 'avatar.jpg')
  def generate_access_token
    JWT.encode({id: self.id, email: self.email, iat: self.iat, exp: self.iat + 10.minute.to_i}, Rails.application.secrets.secret_key_base)
  end

  def generate_refresh_token
    token = JWT.encode({id: self.id, email: self.email, iat: self.iat, exp: self.iat + 15.minute.to_i}, Rails.application.secrets.secret_key_base)
    self.update(refresh_token: token)
    return self.refresh_token
  end

  def update_signin_info
    self.update(sign_in_count: self.sign_in_count += 1, iat: DateTime.now.to_i)
  end

  def update_signin_time
    self.update(iat: DateTime.now.to_i)
  end
end


class AddIatToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :iat, :integer
  end
end

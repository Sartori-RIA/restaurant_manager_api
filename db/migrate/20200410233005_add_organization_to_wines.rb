class AddUserToWines < ActiveRecord::Migration[5.2]
  def change
    add_reference :wines, :organization, foreign_key: true
  end
end
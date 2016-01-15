class AddUsersToDigitalLinks < ActiveRecord::Migration
  def change
    add_column :solidus_digital_links, :user_id, :integer
  end
end

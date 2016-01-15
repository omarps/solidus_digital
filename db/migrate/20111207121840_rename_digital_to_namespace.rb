class RenameDigitalToNamespace < ActiveRecord::Migration
  def change
    rename_table :digitals, :solidus_digitals
    rename_table :digital_links, :solidus_digital_links
  end
end

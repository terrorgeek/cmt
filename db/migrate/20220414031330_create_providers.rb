class CreateProviders < ActiveRecord::Migration[5.2]
  def change
    create_table :providers do |t|
      t.string :npi
      t.string :first_name
      t.string :last_name
      t.string :enumeration_type
      t.string :taxonomy_code
      t.string :taxonomy_desc
      t.string :organization_name
      t.string :address
      t.timestamps
    end
  end
end

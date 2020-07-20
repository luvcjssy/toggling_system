class CreateSchools < ActiveRecord::Migration[6.0]
  def change
    create_table :schools do |t|
      t.string :name
      t.integer :parent_id
      t.integer :payment_type
      t.integer :owner_id
      t.timestamps
    end
  end
end

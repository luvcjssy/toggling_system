class CreateTrackings < ActiveRecord::Migration[6.0]
  def change
    create_table :trackings do |t|
      t.string :child_name
      t.integer :school_class_id
      t.datetime :time_check_in
      t.datetime :time_check_out
      t.timestamps
    end
  end
end

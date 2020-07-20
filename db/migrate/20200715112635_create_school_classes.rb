class CreateSchoolClasses < ActiveRecord::Migration[6.0]
  def change
    create_table :school_classes do |t|
      t.string :name
      t.integer :year
      t.integer :teacher_id
      t.integer :school_id

      t.timestamps
    end
  end
end

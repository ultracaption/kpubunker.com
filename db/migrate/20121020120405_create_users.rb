class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :nickname
      t.string :department

      t.integer :assessment_count

      t.timestamps
    end
  end
end

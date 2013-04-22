class CreateLectures < ActiveRecord::Migration
  def change
    create_table :lectures do |t|
      t.string :title
      t.string :provider
      t.integer :assessment_count
      t.integer :hit_count

      t.float :overall_score
      t.float :presentation_score
      t.float :workload_score
      t.float :grading_score

      t.timestamps
    end
  end
end

class CreatePoints < ActiveRecord::Migration[5.1]
  def change
    create_table :points do |t|
      t.decimal :data

      t.timestamps
    end
  end
end

class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.text :description
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false
      t.string :location, null: false
      t.integer :capacity, null: false
      t.timestamps
      t.check_constraint "starts_at < ends_at", name: "events_ends_after_start"
      t.check_constraint "capacity > 0", name: "events_capacity_positive"
    end
  end
end

class CreateTickets < ActiveRecord::Migration[8.1]
  def change
    create_table :tickets do |t|
      t.references :event, null: false, foreign_key: true
      t.string :token, null: false
      t.index :token, unique: true
      t.string :holder_name, null: false
      t.string :holder_email
      t.string :holder_phone_number
      t.datetime :checked_in_at

      t.timestamps
    end
  end
end

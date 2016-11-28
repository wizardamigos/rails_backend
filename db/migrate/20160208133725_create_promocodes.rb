class CreatePromocodes < ActiveRecord::Migration
  def change
    create_table :promocodes do |t|
      t.string :code

      t.timestamps null: false
    end
  end
end

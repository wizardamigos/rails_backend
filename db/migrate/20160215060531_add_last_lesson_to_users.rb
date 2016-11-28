class AddLastLessonToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_lesson, :string
  end
end

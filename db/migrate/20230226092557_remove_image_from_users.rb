class RemoveImageFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :image, :text
  end
end

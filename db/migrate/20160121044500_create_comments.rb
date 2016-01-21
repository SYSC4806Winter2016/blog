class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :commenttext
      t.string :author
      t.integer :blogpost_id

      t.timestamps
    end
  end
end

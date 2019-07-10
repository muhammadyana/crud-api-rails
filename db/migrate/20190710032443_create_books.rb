class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :title
      t.string :slug
      t.string :author
      t.string :cover
      t.string :publisher
      t.string :description
      t.string :genre
      t.decimal :price, default: 0

      t.timestamps
    end
    add_index :books, :slug, unique: true
  end
end

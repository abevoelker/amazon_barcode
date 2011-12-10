class CreateTableItems < ActiveRecord::Migration
  def up
    create_table :items do |t|
      t.string :asin
      t.string :barcode
    end
  end

  def down
    drop_table :items
  end
end

class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :subject
      t.string :mail_text
      t.integer :user_id

      t.timestamps
    end
  end
end

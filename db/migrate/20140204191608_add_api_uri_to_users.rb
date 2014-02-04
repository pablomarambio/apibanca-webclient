class AddApiUriToUsers < ActiveRecord::Migration
  def change
    add_column :users, :api_uri, :text
  end
end

class RenameTokenInUsersToGithubId < ActiveRecord::Migration
  def change
    rename_column :users, :token, :github_id
  end
end

ActiveAdmin.register User do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :email, :github_id, :city, :first_name, :last_name, :last_lesson
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
  index do
    selectable_column
    id_column
    column :email
    column :github_id
    column :city
    column :first_name
    column :last_name
    column :created_at
    column :updated_at
    column :sign_in_count
    column :last_lesson
    actions
  end

  filter :email
  filter :github_id
  filter :city
  filter :first_name
  filter :last_name
  filter :created_at
  filter :updated_at
  filter :sign_in_count
  filter :last_lesson

  form do |f|
    f.inputs "Edit user" do
      f.input :email
      f.input :github_id
      f.input :city
      f.input :first_name
      f.input :last_name
      f.input :last_lesson
    end
    f.actions
  end

end

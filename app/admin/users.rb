include UserHelper

ActiveAdmin.register User do
  menu priority: 1
  actions :all, except: :destroy

  config.sort_order = 'created_at_desc'
  config.per_page = [25, 50, 100]

  permit_params do
    allowed = %i[name email]
    allowed << %i[password password_confirmation] if current_user == get_resource_ivar
    allowed << :role if current_user.admin?
    allowed
  end

  index download_links: false do
    # id_column
    column(:name){|user| user_avatar_and_link(user) }
    column(:role){|user| user_role(user) }
    column(:created_at)
    actions
  end

  filter :name_or_email_cont, label: 'Search'
  filter :role, as: :select, collection: User.collection_roles
  filter :created_at

  show do
    columns do
      column do
        panel 'Details' do
          attributes_table_for user do
            row(:avatar){|user| image_tag user.gravatar_url, class: 'gravatar' }
            row(:name)
            row(:role){|user| user_role(user) }
            row(:email)
            row(:created_at)
          end
        end
      end

      column span: 2 do
        panel 'Latest translations' do
          table_for user.translations.order(created_at: :desc).limit(10) do
            # column(:game){|translation| game_file_name(translation.game_file.game) }
            column('File'){|translation| link_to translation.game_file.name, admin_game_file_path(translation.game_file) }
            column('#'){|translation| link_to translation.line.row_number.to_s, new_admin_game_file_translation_path(translation.game_file.id, locale: 'fr', line_id: translation.line.id) }
            column(:speaker){|translation| line_face(translation.line) }
            column(:translation) do |translation|
              attributes_table_for [translation] do
                row('English'){|tl| tl.line.english }
                row('🇫🇷 French'){|tl| tl.text }
              end
            end
          end
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      if current_user.admin?
        f.input :role, as: :select, collection: User.collection_roles
      end
      if current_user.admin? || current_user == user
        f.input :password
        f.input :password_confirmation
      end
    end
    f.actions
  end
end

include GameFileHelper

ActiveAdmin.register GameFile do
  menu priority: 2
  actions :all, except: :destroy
  # actions :index, :show

  scope 'Sakura Taisen', :sak_tai1#, default: true
  scope 'Sakura Taisen 2', :sak_tai2
  scope 'Sakura Taisen 3', :sak_tai3

  config.sort_order = 'name_asc'
  config.paginate = false

  permit_params do
    allowed = %i[description]
    allowed
  end

  index download_links: false do
    # id_column
    if !params[:scope] && (!params[:q] || !params[:q][:game_eq])
      column(:game){|game_file| game_file_game(game_file) }
    end
    column(:name){|game_file| link_to game_file.name, admin_game_file_path(game_file) }
    column(:description)
    column(:line_count)
    column(:updated_at)
    actions do |game_file|
      item 'Download', download_admin_game_file_path(game_file)
    end
  end

  filter :name_cont, label: 'Search'
  filter :created_at

  show do
    columns do
      column do
        panel 'Details' do
          attributes_table_for game_file do
            row(:game){|game_file| game_file_name(game_file.game) }
            row(:name)
            row(:description)
            row(:line_count)
            row(:updated_at)
          end
        end
      end

      column span: 4 do
        panel 'Lines' do
          @translations = Translation.where(game_file_id: game_file.id, locale: current_user.locale).pluck(:line_id, :text).to_h

          table_for game_file.lines.order(row_number: :asc) do
            column('#') do |line|
              [
                "ID ##{line.row_number.to_s}",
                "Order: #{line.order}",
                line.crc.upcase
              ].join('<br />').html_safe
            end
            column('Speaker'){|line| line_face(line) }
            # column('Japanese (OCR'){|line| line.japanese_ocr.try(:gsub, "\n", "<br />") }
            column('English'){|line| line.english }
            column(user_locale(current_user.locale)){|line| @translations[line.id] }
            column do |line|
              if @translations[line.id].presence
                link_to 'Edit', new_admin_game_file_translation_path(game_file.id, locale: current_user.locale, line_id: line.id)
              else
                link_to 'Translate', new_admin_game_file_translation_path(game_file.id, locale: current_user.locale, line_id: line.id)
              end
            end
            # column('ID'){|line| line.line_id }
            # column('Order'){|line| line.order }
            # column('CRC'){|line| line.crc}
            # column('Has a Duplicate'){|line| line.has_dupe ? 'true' : 'false' }
          end
        end
      end
    end
  end

  member_action(:download) do
    flash[:error] = 'The "Download" feature is coming later.'
    redirect_back fallback_location: admin_game_files_path
    # game_file = ::GameFile.find(params[:id])
  end

  action_item(:download, only: :show) do
    link_to('Download', download_admin_game_file_path(game_file))
  end

  form do |f|
    f.inputs do
      f.input :description
    end
    f.actions
  end
end

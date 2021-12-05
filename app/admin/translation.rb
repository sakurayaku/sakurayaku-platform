include GameFileHelper


ActiveAdmin.register Translation do
  menu false
  actions :all, except: [:destroy]#, :index, :show]
  belongs_to :game_file

  config.filters = false
  # config.sort_order = 'row_number_asc'
  config.paginate = false

  # breadcrumb do
  #   [
  #     link_to('Admin', admin_root_path),
  #     link_to('Game files', admin_game_files_path),
  #     game_file.name
  #   ]
  # end

  permit_params do
    allowed = %i[user_id text]
    allowed
  end

  controller do
    def index
      redirect_to admin_game_file_path(params[:game_file_id])
    end

    def show
      redirect_to edit_admin_game_file_translation_path(params[:game_file_id], resource.id)
    end

    def update
      params[:user_id] = current_user.id
      super
    end
    def new
      @translation = Translation.find_by(
        game_file_id: params[:game_file_id],
        locale: params[:locale],
        line_id: params[:line_id]
      )
      if @translation
        return redirect_to edit_admin_game_file_translation_path(params[:game_file_id], @translation)
      end
      @translation = Translation.create!(
        game_file_id: params[:game_file_id],
        locale: params[:locale],
        line_id: params[:line_id],
        user_id: current_user.id,
        text: ''
      )
      redirect_to edit_admin_game_file_translation_path(params[:game_file_id], @translation)
    end
  end

  # index download_links: false do
  #   column('#') do |line|
  #     [
  #       ('ID #' + line.row_number.to_s),
  #       ('Order: ' + line.order),
  #       line.crc.upcase
  #     ].join('<br />').html_safe
  #   end
  #   column('Speaker'){|line| line_face(line) }
  #   # column('Japanese'){|line| line_japanese(line) }
  #   column('English'){|line| line.english }
  #   column do |line|
  #     link_to 'Edit', edit_admin_game_file_line_path(game_file.id, line.id)
  #   end
  #   column(user_locale(current_user.locale)){|line| @translations_fr[line.id] }
  # end

  form do |f|
    columns do
      column do
        panel 'Game file' do
          attributes_table_for translation.game_file do
            row(:game){|game_file| game_file_name(game_file.game) }
            row(:name)
            row(:description)
            row(:line_count)
            row(:updated_at)
          end
        end

        panel 'Line data' do
          attributes_table_for translation.line do
            row('ID'){|line| line.row_number.to_s }
            row('Order'){|line| line.order }
            row('CRC'){|line| line.crc.upcase }
          end
        end
      end

      column span: 4 do
        columns do
          @prev_line = Line.find_by(game_file_id: translation.game_file_id, row_number: translation.line.row_number - 1)
          @next_line = Line.find_by(game_file_id: translation.game_file_id, row_number: translation.line.row_number + 1)

          column span: 2 do
            @prev_translation = Translation.find_by(
              game_file_id: translation.game_file_id,
              locale: translation.locale,
              line_id: @prev_line&.id
            )
            panel 'Previous line' do
              if @prev_line
                table_for [@prev_line] do
                  column('Speaker'){|line| line_face(line) }
                  column('Japanese'){|line| line_japanese(line) }
                end
                attributes_table_for @prev_line do
                  row('English'){|line| line.english }
                  row(user_locale(current_user.locale)){|line| @prev_translation&.text }
                end
                div do
                  if @prev_translation
                    link_to 'Previous', edit_admin_game_file_translation_path(translation.game_file_id, @prev_translation.id), class: 'button'
                  else
                    link_to 'Previous', new_admin_game_file_translation_path(translation.game_file_id, locale: translation.locale, line_id: @prev_line.id), class: 'button'
                  end
                end
              else
                div{ 'N/A'}
              end
            end
          end
          column span: 2 do
            @next_translation = Translation.find_by(
              game_file_id: translation.game_file_id,
              locale: translation.locale,
              line_id: @next_line&.id
            )

            panel 'Next line' do
              if @next_line
                table_for [@next_line] do
                  column('Speaker'){|line| line_face(line) }
                  column('Japanese'){|line| line_japanese(line) }
                end
                attributes_table_for @next_line do
                  row('English'){|line| line.english }
                  row(user_locale(current_user.locale)){|line| @next_translation&.text }
                end
                div do
                  if @next_translation
                    link_to 'Next', edit_admin_game_file_translation_path(translation.game_file_id, @next_translation.id), class: 'button'
                  else
                    link_to 'Next', new_admin_game_file_translation_path(translation.game_file_id, locale: translation.locale, line_id: @next_line.id), class: 'button'
                  end
                end
              else
                div{ 'N/A' }
              end
            end
          end
        end

        panel 'Line' do
          table_for [translation.line] do
            column('Speaker'){|line| line_face(line) }
            column('Japanese'){|line| line_japanese(line) }
            column('English'){|line| line.english }

          end
          attributes_table_for translation do
            row(user_locale(current_user.locale)){|line| translation.text }
          end
        end
        panel 'Translation' do
          f.inputs do
            f.input :text
          end
          f.actions
        end
      end
    end
  end
end

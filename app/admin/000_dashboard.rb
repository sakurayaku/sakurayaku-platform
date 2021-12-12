ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: 'Progress' do
    files_ar = GameFile.
          joins_lines.
          joins_translation('fr')#.
          # joins_translation('es')
    files = files_ar.order(name: :asc).
          select(%[
            game_files.*,
            lines_count.count_lines,
            translations_fr.count_fr
          ]).to_a
    # locales = [current_user.locale, %w(fr es)].flatten.uniq
    locales = [current_user.locale]
    panel 'Progress' do
      gf_recap = files_ar.select(%[
        0 AS id,
        'Total' AS name,
        SUM(lines_count.count_lines)::int AS count_lines,
        SUM(translations_fr.count_fr)::int AS count_fr
      ])
      files.unshift(gf_recap[0])

      table_for files do
        column('File') do |game_file|
          game_file.id > 0 ? link_to(game_file.name, admin_game_file_path(game_file)) : game_file.name
        end
        column('Lines'){|game_file| game_file.read_attribute('count_lines') }
        locales.each do |locale|
          column("#{user_locale(locale)}"){|game_file| game_file.read_attribute("count_#{locale}") || 0 }
          column('Progress') do |game_file|
            count_total = game_file.read_attribute('count_lines')
            count_locale = game_file.read_attribute("count_#{locale}") || 0
            percentage = ((100 * count_locale) / count_total.to_f).round(2)

            color = case percentage
            when 91..100; 'success'
            when 51..90;  'info'
            when 11..50;  'warning'
            else;         'danger'
            end

            div(class: 'progress') do
              div(class: "progress-bar bg-#{color}", role: 'progressbar', style: "width: #{percentage}%") do

                "#{percentage}%"
              end
            end
          end
        end
      end
    end
  end
end

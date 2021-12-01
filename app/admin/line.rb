# include GameFileHelper

# ActiveAdmin.register Line do
#   menu false
#   actions :all, except: [:destroy]#:index, :show
#   belongs_to :game_file

#   config.filters = false
#   config.sort_order = 'row_number_asc'
#   config.paginate = false

#   permit_params do
#     allowed = %i[translation_fr]
#     allowed
#   end

#   index download_links: false do
#     @translations_fr = Translation.where(game_file_id: game_file.id, locale: 'fr').pluck(:line_id, :text).to_h
#     column('#') do |line|
#       [
#         ('ID #' + line.row_number.to_s),
#         ('Order: ' + line.order),
#         line.crc.upcase
#       ].join('<br />').html_safe
#     end
#     column('Speaker'){|line| line_face(line) }
#     # column('Japanese'){|line| line_japanese(line) }
#     column('English'){|line| line.english }
#     column do |line|
#       link_to 'Edit', edit_admin_game_file_line_path(game_file.id, line.id)
#     end
#     column('🇫🇷 French'){|line| @translations_fr[line.id] }
#   end

#   form do |f|
#     columns do
#       column do
#         panel 'Game file' do
#           attributes_table_for line.game_file do
#             row(:game){|game_file| game_file_name(game_file.game) }
#             row(:name)
#             row(:description)
#             row(:line_count)
#             row(:updated_at)
#           end
#         end

#         panel 'Line data' do
#           attributes_table_for line do
#             row('ID'){|line| line.row_number.to_s }
#             row('Order'){|line| line.order }
#             row('CRC'){|line| line.crc.upcase }
#           end
#         end
#       end

#       column span: 4 do
#         panel 'Original line' do
#           table_for [line] do
#             column('Speaker'){|line| line_face(line) }
#             column('Japanese'){|line| line_japanese(line) }
#             column('English'){|line| line.english }
#             # column('🇫🇷 French'){|line| @translations_fr[line.id] }
#           end
#         end
#         panel 'Translation' do
#           f.inputs do

#             f.input :translation_fr
#           end
#           f.actions
#         end
#       end
#     end
#   end
# end

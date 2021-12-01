require 'nokogiri'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# User.create!(name: 'foobar', email: 'foo@foo.foo', password: 'foobar', password_confirmation: 'foobar') if Rails.env.development?

correspondance = File.read('./../Webpages/ExtractedData/md5sum_all.txt').chomp.split("\n").map do |line|
  line = line.split(' ')
  ["/ExtractedData/#{line.last}", line.first]
end.to_h
correspondance['/ExtractedData/Faces/UnknownFace.png'] = '750654cd7110d2ef9c57d1d70ff3e0e3'


Dir['../Webpages/Html/*.php'].each do |html_file|
  game_file = html_file.split('/').last.split('.').first
  game_file = GameFile.find_or_create_by!(game: 'SakTai1', name: game_file)
  game_file.reload

  html_file = File.read(html_file)
  html_doc = Nokogiri::HTML(html_file){|conf| conf.noblanks }
  html_doc.xpath(%[//tr])[1..-1].map do |element|
    elts = element.children
    line = Line.find_or_create_by(game_file_id: game_file.id, row_number: elts[0].content.to_s)

    elt_face = elts[1].children.first['src'].gsub(/^../, '').gsub('\\', '/')
    raise elt_face unless elt_face && correspondance[elt_face]

    elt_jap = elts[2].children.first['src'].gsub(/^../, '').gsub('\\', '/')
    raise elt_jap unless elt_jap &&  correspondance[elt_jap]
    # puts "_#{elt_face}"
    line_data = {
      face: correspondance[elt_face],
      speaker: 'Und.',
      japanese: correspondance[elt_jap],
      english: elts[3].content.strip.force_encoding('iso-8859-1').encode('utf-8'),
      line_id: elts[4].content.strip,
      order: elts[5].content.gsub(/^Order: /, '').strip,
      crc: elts[6].content.strip,
      has_dupe: elts[7].content.strip
    }
    # puts "__#{line_data}__"
    line.update!(line_data)
  end

  game_file.update(line_count: game_file.lines.count)
end
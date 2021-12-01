module GameFileHelper
  def game_file_name(scope)
    case scope
    when 'SakTai1'
      [
        image_tag('/SakTai1Cover.jpg', style: 'width: 96px; height: 96px;'),
        '<br />',
        '<b>Sakura Taisen</b>'
      ].join.html_safe
    when 'SakTai2'
      [
        image_tag('/SakTai2Cover.jpg', style: 'width: 96px; height: 96px;'),
        '<br />',
        '<b>Sakura Taisen 2</b>'
      ].join.html_safe
    when 'SakTai3'
      [
        image_tag('/SakTai3Cover.jpg', style: 'width: 96px; height: 96px;'),
        '<br />',
        '<b>Sakura Taisen 3</b>'
      ].join.html_safe
    else
      'Unknown'
    end
  end

  def game_file_game(game_file)
    case game_file.game
    when 'SakTai1'
      [
        image_tag('/SakTai1Cover.jpg', class: 'gravatar-16'),
        'Sakura Taisen'
      ].join.html_safe
    when 'SakTai2'
      [
        image_tag('/SakTai2Cover.jpg', class: 'gravatar-16'),
        'Sakura Taisen 2'
      ].join.html_safe
    when 'SakTai3'
      [
        image_tag('/SakTai3Cover.jpg', class: 'gravatar-16'),
        'Sakura Taisen 3'
      ].join.html_safe
    else
      'Unknown'
    end
  end

  def line_face(line)
    return '' unless line.face
    image_tag "https://sakurayaku-assets.s3.eu-west-3.amazonaws.com/#{line.face}.png"
  end

  def line_japanese(line)
    return '' unless line.japanese
    image_tag "https://sakurayaku-assets.s3.eu-west-3.amazonaws.com/#{line.japanese}.png"
  end
end

module UserHelper
  def user_role(user)
    case user.role
    when 'admin'
      b(style: 'color: red;'){ 'Administrator' }
    when 'moderator'
      span(style: 'color: blue;'){ 'Moderator' }
    else
      'User'
    end
  end

  def user_avatar_and_link(user)
    [
      image_tag(user.gravatar_url, class: 'gravatar-16'),
      link_to(user.name, admin_user_path(user))
    ].join.html_safe
  end
end

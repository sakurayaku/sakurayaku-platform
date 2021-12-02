class AuthorizationAdapter < ActiveAdmin::AuthorizationAdapter
  def authorized?(action, subject = nil)
    return true if action == :read
    return true if user.admin?
    return false if action == :destroy

    case subject
    when User
      return false if subject.admin?
      return true if user.moderator?
      return action == :update && user.id == subject.id
    when GameFile
      return action == :update
    when Translation
      return true
    # when Line
    #   false

    # when Line
    #   return false if action == :create
    # when Translation
    #   return tru
    else
      false
    end
    false
  end
end

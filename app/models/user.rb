class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable
  include Gravtastic
  gravtastic

  has_many :translations

  def admin?
    role == 'admin'
  end

  def moderator?
    role == 'admin' || role == 'moderator'
  end

  def can_be_edited_by?(other_user)
    return true if other_user.id == id
    return true if other_user.moderator?

    false
  end

  class << self
    def collection_roles
      [['Administrator', 'admin'], ['Moderator', 'moderator']]
    end
  end
end

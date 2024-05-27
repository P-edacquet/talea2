class AdminPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def audits?
    true
  end

  def create_new_user?
    user && user.manager?
  end

  def create_new_user_do?
    create_new_user?
  end
end
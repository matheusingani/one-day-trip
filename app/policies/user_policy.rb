class UserPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def index?
    user.admin? # Example: Only admins can access the user index
  end

  def show?
    user.admin? || record == user # Example: Admins and the user itself can see their profile
  end

  # Define other actions like create?, update?, destroy?, etc

end

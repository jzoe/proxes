# frozen_string_literal: true
require_relative 'application_policy'

module ProxES
  class IdentityPolicy < ApplicationPolicy
    def register?
      true
    end

    def permitted_attributes
      [:username, :password, :password_confirmation]
    end

    class Scope < ApplicationPolicy::Scope
      def resolve
        if user.super_admin?
          scope.all
        else
          []
        end
      end
    end
  end
end

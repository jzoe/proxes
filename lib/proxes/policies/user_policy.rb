# frozen_string_literal: true
require 'proxes/policies/application_policy'

module ProxES
  class UserPolicy < ApplicationPolicy
    def create?
      user && user.super_admin?
    end

    def list?
      create?
    end

    def read?
      user && (record.id == user.id || user.super_admin?)
    end

    def update?
      read?
    end

    def delete?
      create?
    end

    def register?
      true
    end

    def permitted_attributes
      attribs = [:email, :name, :surname]
      attribs << :role_id if user.super_admin?
      attribs
    end

    class Scope < ApplicationPolicy::Scope
      def resolve
        if user && user.super_admin?
          scope
        else
          scope.where(id: -1)
        end
      end
    end
  end
end

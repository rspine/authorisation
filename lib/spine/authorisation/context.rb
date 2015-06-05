require 'spine/hub'

module Spine
  module Authorisation
    module Context
      include Hub::Publisher

      def subject
        raise NotImplementedError, 'Context requires subject'
      end

      def role
        raise NotImplementedError, 'Context requires role'
      end

      def authorize(action, resource)
        return false unless subject

        restriction = restricted?(action, resource)
        if restriction
          publish(:restricted, self, restriction, action, resource)
          false
        elsif !granted?(action, resource)
          publish(:denied, self, action, resource)
          false
        else
          publish(:granted, self, action, resource)
          true
        end
      end

      private

      def granted?(action, resource)
        Authorisation.permissions.granted?(role, action, resource)
      end

      def restricted?(action, resource)
        Authorisation.restrictions.restricted?(self, action, resource)
      end
    end
  end
end

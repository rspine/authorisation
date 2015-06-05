require 'spine/permissions'
require 'spine/restrictions'

module Spine
  module Authorisation
    module Registrations
      def permissions(&block)
        @permissions ||= ::Spine::Permissions::Roles.new
        @permissions.instance_eval(&block) if block_given?
        @permissions
      end

      def restrictions(&block)
        @restrictions ||= ::Spine::Restrictions::Collection.new
        @restrictions.instance_eval(&block) if block_given?
        @restrictions
      end
    end
  end
end

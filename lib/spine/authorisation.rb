module Spine
  module Authorisation
    autoload :Context, 'spine/authorisation/context'
    autoload :Registrations, 'spine/authorisation/registrations'
    autoload :Engine, 'spine/authorisation/engine'

    extend Registrations
  end
end

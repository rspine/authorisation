module Spine
  module Authorisation
    module Engine
      module Configuration
        def authorisation
          ::Spine::Authorisation
        end
      end

      module Loader
        extend self

        def call(app)
          require app.root.join('config', 'authorisation')
        end
      end

      extend self

      def configuration
        Configuration
      end

      def loader
        Loader
      end
    end
  end
end


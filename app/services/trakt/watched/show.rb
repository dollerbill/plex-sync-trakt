# frozen_string_literal: true

module Trakt
  module Watched
    class Show < Base
      private

      def type
        'shows'
      end
    end
  end
end

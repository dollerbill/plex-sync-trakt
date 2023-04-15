# frozen_string_literal: true

module Trakt
  module Scrobble
    class Episode < Base
      private

      def body
        super.except('show')
      end
    end
  end
end

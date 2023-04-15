# frozen_string_literal: true

module Trakt
  module Watched
    class Movie < Base
      private

      def type
        'movies'
      end
    end
  end
end

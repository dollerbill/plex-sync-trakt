# frozen_string_literal: true

module Trakt
  module Search
    class Movie < Base
      private

      def type
        'movie'
      end

      def result_matches?(result)
        result['movie']['title'].downcase == name.downcase && result['movie']['year'].to_s == year
      end
    end
  end
end

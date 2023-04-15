# frozen_string_literal: true

module Trakt
  module Search
    class Episode < Base
      private

      def type
        'episode'
      end

      def url
        super + "+#{show_name.split.join('+')}"
      end

      def show_name
        media['grandparent_title']
      end

      def result_matches?(result)
        result['episode']['title'].downcase == name.downcase &&
          result['show']['title'].downcase == show_name.downcase &&
          result['episode']['season'] == media['parent_index'].to_i &&
          result['episode']['number'] == media['index'].to_i
      end
    end
  end
end

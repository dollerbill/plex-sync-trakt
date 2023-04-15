# frozen_string_literal: true

module Trakt
  module Search
    class RateLimitError < StandardError; end

    class Base
      attr_reader :media

      def self.call(media)
        new(media).call
      end

      def initialize(media)
        @media = media
      end

      def call
        result = HTTP.headers(headers).get(url)
        raise RateLimitError if result.code == 429 || JSON.parse(result.headers['x-ratelimit'])['remaining'] <= 1

        match = result.parse.max_by { |m| m['score'] }
        return unless match

        result_matches?(match) ? match : nil
      end

      private

      def headers
        BASE_HEADERS
      end

      def name
        media['title']
      end

      def year
        media['year']
      end

      def type
        raise NotImplementedError, 'You must implement this method in a subclass.'
      end

      def url
        "#{TRAKT_BASE_URL}/search/#{type}?query=#{name.split.join('+')}"
      end
    end
  end
end

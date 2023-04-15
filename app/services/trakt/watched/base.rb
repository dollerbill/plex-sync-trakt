# frozen_string_literal: true

module Trakt
  module Watched
    class Base
      def self.call
        new.call
      end

      def call
        HTTP.headers(headers).get(url).parse
      end

      private

      def headers
        BASE_HEADERS
      end

      def url
        "#{TRAKT_BASE_URL}/users/#{TRAKT_USERNAME}/watched/#{type}"
      end
    end
  end
end

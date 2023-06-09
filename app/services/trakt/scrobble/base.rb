# frozen_string_literal: true

module Trakt
  module Scrobble
    class TokenExpired < StandardError; end
    class Base
      attr_reader :media

      def self.call(media)
        new(media).call
      end

      def initialize(media)
        @media = media
      end

      def call
        raise TokenExpired if token_expired?

        result = HTTP.headers(headers).post(url, json: body)
        raise RateLimitError, result if result.code == 429

        result
      end

      private

      def token_expired?
        Time.parse(TRAKT_ACCESS_TOKEN_EXPIRES_AT) < Time.now
      end

      def headers
        BASE_HEADERS.merge('Authorization' => "Bearer #{TRAKT_ACCESS_TOKEN}")
      end

      def body
        media.except('type', 'score').merge({ 'progress' => 100 })
      end

      def url
        "#{TRAKT_BASE_URL}/scrobble/stop"
      end
    end
  end
end

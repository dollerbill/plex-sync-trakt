# frozen_string_literal: true

module Trakt
  module Authenticate
    class Refresh
      include Token

      def self.call
        new.refresh_token
      end

      def refresh_token
        json = base_json.merge({ 'refresh_token' => TRAKT_REFRESH_TOKEN, 'grant_type' => 'refresh_token' })
        response = HTTP.post(OAUTH_TOKEN_URL, json:)

        if response.code == 200
          handle_response(response)
        else
          puts "Error: #{response.code}"
        end
      end
    end
  end
end
# frozen_string_literal: true

module Trakt
  class Authenticate
    DEVICE_CODE_URL = 'https://api.trakt.tv/oauth/device/code'
    DEVICE_TOKEN_URL = 'https://api.trakt.tv/oauth/device/token'
    OAUTH_TOKEN_URL = 'https://api.trakt.tv/oauth/token'

    def self.access_token
      new.access_token
    end

    def self.refresh_token
      new.refresh_token
    end

    def access_token
      response = HTTP.post(DEVICE_CODE_URL, json: { 'client_id' => TRAKT_ID })
      device_code_data = JSON.parse(response.body.to_s)

      device_code = device_code_data['device_code']
      user_code = device_code_data['user_code']
      verification_url = device_code_data['verification_url']
      interval = device_code_data['interval']

      puts "Please go to #{verification_url} and enter the code: #{user_code}"
      puts 'Waiting for user authorization...'

      access_token = nil
      loop do
        sleep(interval)

        json = base_json.merge({ 'code' => device_code })
        response = HTTP.post(DEVICE_TOKEN_URL, json:)

        case response.code
        when 200
          handle_response(response)
          break
        when 400
          # Waiting for the user to authorize the app, continue polling
        when 418, 429
          puts 'Slow down polling rate'
        else
          puts "Error: #{response.code}"
          break
        end
      end
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

    def base_json
      { 'client_id' => TRAKT_ID, 'client_secret' => TRAKT_SECRET }
    end

    def handle_response(response)
      token_data = JSON.parse(response.body.to_s)
      access_token = token_data['access_token']
      refresh_token = token_data['refresh_token']
      expires_at = token_data['created_at'] + token_data['expires_in']
      puts "Access token: #{access_token}"
      puts "Refresh token: #{refresh_token}"
      puts "Expires at: #{Time.at(expires_at)}"
      puts 'Store these tokens in your environment variables or application secrets for future use.'
    end
  end
end

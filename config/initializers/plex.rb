# frozen_string_literal: true

Plex.configure do |config|
  config.auth_token = Rails.application.credentials[:PLEX_AUTH_TOKEN]
end

PLEX_SERVER_URL = Rails.application.credentials[:PLEX_SERVER].freeze
PLEX_PORT = Rails.application.credentials[:PLEX_PORT].freeze

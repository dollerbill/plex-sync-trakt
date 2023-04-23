# frozen_string_literal: true

module Plex
  module Sync
    class Base
      def self.call
        new.call
      end

      def ignore_list
        file_path = Rails.root.join('config', 'ignore_list.yml')

        if File.exist?(file_path)
          YAML.load_file(file_path).deep_symbolize_keys
        else
          { movies: [], tv_shows: [] }
        end
      end

      def call
      rescue Trakt::RateLimitError => e
        raise StandardError, e.message
      end

      def plex_server
        @plex_server ||= Plex::Server.new(PLEX_SERVER_URL, PLEX_PORT)
      end

      def server
        raise NotImplementedError, 'You must implement this method in a subclass.'
      end

      def library
        plex_server.library.sections.detect { |s| s.title =~ /#{server}/ }
      end

      def watched_media
        @watched_media ||= "Trakt::Watched::#{server}".constantize.call
      end
    end
  end
end

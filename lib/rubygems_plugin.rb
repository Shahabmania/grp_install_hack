require 'rubygems/commands/install_command'
require 'rubygems/gemcutter_utilities'
require 'rubygems/remote_fetcher'

module Gem::GitHub
  def self.included base
    base.class_eval do
      base.alias_method :orig_initialize, :initialize
      base.alias_method :orig_execute, :execute
      def initialize
        orig_initialize
        # add the key option so we can get the header
        add_key_option
      end
      def execute
        unless api_key.nil?
          # The fetcher is a singleton instance, so just stick the header there
          # to make sure it's used; yes, this is terrible
          fetcher = Gem::RemoteFetcher.fetcher
          fetcher.headers["Authorization"] = api_key
        end
        orig_execute
      end
    end
  end
end

Gem::Commands::InstallCommand.send :include, Gem::GemcutterUtilities
Gem::Commands::InstallCommand.send :include, Gem::GitHub

require 'slimerjs/version'
require 'fileutils'

module SlimerJS
  module Lightweight
    class UnknownPlatform < StandardError; end;

  end
end

require 'slimerjs/lighweight/platform'

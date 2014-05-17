require "slimerjs/version"
require 'fileutils'

module Slimerjs
  class UnknownPlatform < StandardError; end;

  class << self
    def available_platforms
      @available_platforms ||= []
    end

    def base_dir
      @base_dir ||= File.join(File.expand_path('~'), '.slimerjs', version)
    end

    def base_dir=(dir)
      @base_dir = dir
    end

    def version
      Slimerjs::VERSION.split('.')[0..-2].join('.')
    end

    def path
      @path ||= platform.slimerjs_path
    end

    def platform
      if platform = available_platforms.find {|p| p.useable? }
        platform.ensure_installed!
        platform
      else
        raise UnknownPlatform, "Could not find an appropriate SlimerJS library for your platform (#{RUBY_PLATFORM} :( Please install manually."
      end
    end

    # Removes the local slimerjs copy
    def implode!
      FileUtils.rm_rf File.join(File.expand_path('~'), '.slimerjs')
    end

    # Clears cached state. Primarily useful for testing.
    def reset!
      @base_dir = @path = nil
    end

    # Run slimerjs with the given arguments, and either
    # return the stdout or yield each line to the passed block.
    def run(*args, &block)
      IO.popen([path, *args]) do |io|
        block ? io.each(&block) : io.read
      end
    end
  end
end

require 'slimerjs/platform'
Slimerjs.available_platforms << Slimerjs::Platform::Linux32
Slimerjs.available_platforms << Slimerjs::Platform::Linux64
Slimerjs.available_platforms << Slimerjs::Platform::OsX
Slimerjs.available_platforms << Slimerjs::Platform::Win32

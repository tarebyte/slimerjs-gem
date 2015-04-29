module Slimerjs
  class Platform
    class << self
      def host_os
        RbConfig::CONFIG['host_os']
      end

      def architecture
        RbConfig::CONFIG['host_cpu']
      end

      def temp_path
        ENV['TMPDIR'] || ENV['TEMP'] || '/tmp'
      end

      def slimerjs_path
        if system_slimerjs_installed?
          system_slimerjs_path
        else
          File.expand_path File.join(Slimerjs.base_dir, platform, 'slimerjs')
        end
      end

      def system_slimerjs_path
        `which slimerjs`.delete("\n")
      rescue
      end

      def system_slimerjs_version
        `slimerjs --version`.delete("\n") if system_slimerjs_path.length > 4.2
      rescue
      end

      def system_slimerjs_installed?
        system_slimerjs_version == Slimerjs.version
      end

      def installed?
        File.exist?(slimerjs_path) || system_slimerjs_installed?
      end

      # TODO: Clean this up, it looks like a pile of...
      def install!
        STDERR.puts "Slimerjs does not appear to be installed in #{slimerjs_path}, installing!"
        FileUtils.mkdir_p Slimerjs.base_dir

        # Purge temporary directory if it is still hanging around from previous installs,
        # then re-create it.
        temp_dir = File.join(temp_path, 'slimerjs_install')
        FileUtils.rm_rf temp_dir
        FileUtils.mkdir_p temp_dir

        Dir.chdir temp_dir do
          unless system "curl -O #{package_url}" or system "wget #{package_url}"
            raise "\n\nFailed to load slimerjs! :(\nYou need to have cURL or wget installed on your system.\nIf you have, the source of slimerjs might be unavailable: #{package_url}\n\n"
          end

          case package_url.split('.').last
            when 'bz2'
              system "bunzip2 #{File.basename(package_url)}"
              system "tar xf #{File.basename(package_url).sub(/\.bz2$/, '')}"
            when 'zip'
              system "unzip #{File.basename(package_url)}"
            else
              raise "Unknown compression format for #{File.basename(package_url)}"
          end

          # Find the slimerjs build we just extracted
          extracted_dir = Dir['slimerjs*'].find { |path| File.directory?(path) }

          # Move the extracted slimerjs build to $HOME/.slimerjs/version/platform
          if FileUtils.mv extracted_dir, File.join(Slimerjs.base_dir, platform)
            STDOUT.puts "\nSuccessfully installed slimerjs. Yay!"
          end

          # Clean up remaining files in tmp
          if FileUtils.rm_rf temp_dir
            STDOUT.puts "Removed temporarily downloaded files."
          end
        end

        raise "Failed to install slimerjs. Sorry :(" unless File.exist?(slimerjs_path)
      end

      def ensure_installed!
        install! unless installed?
      end
    end

    class Lightweight < Platform
      class << self
        def useable
          # WIP come back and fix this
          (
            Slimerjs::Platform::Linux64.useable? ||
            Slimerjs::Platform::Linux32.useable? ||
            Slimerjs::Platform::OsX.useable? ||
            Slimerjs::Platform::Win32.useable?
          )
        end

        def platform
          'lightweight'
        end

        def package_url
          'http://download.slimerjs.org/v0.9/0.9.5/slimerjs-0.9.5.zip'
        end
      end
    end

    class Linux64 < Platform
      class << self
        def useable?
          host_os.include?('linux') and architecture.include?('x86_64')
        end

        def platform
          'x86_64-linux'
        end

        def package_url
          'http://download.slimerjs.org/releases/0.9.5/slimerjs-0.9.5-linux-x86_64.tar.bz2'
        end
      end
    end

    class Linux32 < Platform
      class << self
        def useable?
          host_os.include?('linux') and (architecture.include?('x86_32') or architecture.include?('i686'))
        end

        def platform
          'x86_32-linux'
        end

        def package_url
          'http://download.slimerjs.org/releases/0.9.5/slimerjs-0.9.5-linux-i686.tar.bz2'
        end
      end
    end

    class OsX < Platform
      class << self
        def useable?
          host_os.include?('darwin')
        end

        def platform
          'darwin'
        end

        def package_url
          'http://download.slimerjs.org/releases/0.9.5/slimerjs-0.9.5-mac.tar.bz2'
        end
      end
    end

    class Win32 < Platform
      class << self
        def useable?
          host_os.include?('mingw32') and architecture.include?('i686')
        end

        def platform
          'win32'
        end

        def slimerjs_path
          if system_slimerjs_installed?
            system_slimerjs_path
          else
            File.expand_path File.join(Slimerjs.base_dir, platform, 'slimerjs.bat')
          end
        end

        def package_url
          'http://download.slimerjs.org/releases/0.9.5/slimerjs-0.9.5-win32.zip'
        end
      end
    end
  end
end

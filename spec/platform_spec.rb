require 'spec_helper'

describe Slimerjs::Platform do
  before(:each) { Slimerjs.reset! }
  describe "with a system install present" do
    describe "#system_slimerjs_installed?" do
      it "is true when the system version matches Slimerjs.version" do
        Slimerjs::Platform.should_receive(:system_slimerjs_version).and_return(Slimerjs.version)
        expect(Slimerjs::Platform.system_slimerjs_installed?).to be_true
      end

      it "is false when the system version does not match Slimerjs.version" do
        Slimerjs::Platform.should_receive(:system_slimerjs_version).and_return('0.9.1')
        expect(Slimerjs::Platform.system_slimerjs_installed?).to be_false
      end

      it "is false when there's no system version" do
        Slimerjs::Platform.should_receive(:system_slimerjs_version).and_return(nil)
        expect(Slimerjs::Platform.system_slimerjs_installed?).to be_false
      end
    end
  end

  describe "on a 64 bit linux" do
    before do
      Slimerjs::Platform.stub(:host_os).and_return('linux-gnu')
      Slimerjs::Platform.stub(:architecture).and_return('x86_64')
    end

    it "reports the Linux64 Platform as useable" do
      Slimerjs::Platform::Linux64.should be_useable
    end

    describe "without system install" do
      before(:each) { Slimerjs::Platform.stub(:system_slimerjs_version).and_return(nil) }

      it "returns the correct slimer js executable path for the platform" do
        Slimerjs.path.should =~ /x86_64-linux\/bin\/slimerjs$/
      end
    end

    describe "with system install" do
      before(:each) do
        Slimerjs::Platform.stub(:system_slimerjs_version).and_return(Slimerjs.version)
        Slimerjs::Platform.stub(:system_slimerjs_path).and_return('/tmp/path')
      end

      it "returns the correct slimer js executable path for the platform" do
        expect(Slimerjs.path).to be == '/tmp/path'
      end
    end

    it "reports the Linux32 platform as unuseable" do
      Slimerjs::Platform::Linux32.should_not be_useable
    end

    it "reports the Darwin platform as unuseable" do
      Slimerjs::Platform::OsX.should_not be_useable
    end

    it "reports the Win32 Platform as unuseable" do
      Slimerjs::Platform::Win32.should_not be_useable
    end
  end

  describe "on a 32 bit linux" do
    before do
      Slimerjs::Platform.stub(:host_os).and_return('linux-gnu')
      Slimerjs::Platform.stub(:architecture).and_return('x86_32')
    end

    it "reports the Linux32 Platform as useable" do
      Slimerjs::Platform::Linux32.should be_useable
    end

    it "reports another Linux32 Platform as useable" do
      Slimerjs::Platform.stub(:host_os).and_return('linux-gnu')
      Slimerjs::Platform.stub(:architecture).and_return('i686')
      Slimerjs::Platform::Linux32.should be_useable
    end

    describe "without system install" do
      before(:each) { Slimerjs::Platform.stub(:system_slimerjs_version).and_return(nil) }

      it "returns the correct slimer js executable path for the platform" do
        Slimerjs.path.should =~ /x86_32-linux\/bin\/slimerjs$/
      end
    end

    describe "with system install" do
      before(:each) do
        Slimerjs::Platform.stub(:system_slimerjs_version).and_return(Slimerjs.version)
        Slimerjs::Platform.stub(:system_slimerjs_path).and_return('/tmp/path')
      end

      it "returns the correct slimer js executable path for the platform" do
        expect(Slimerjs.path).to be == '/tmp/path'
      end
    end

    it "reports the Linux64 platform as unuseable" do
      Slimerjs::Platform::Linux64.should_not be_useable
    end

    it "reports the Darwin platform as unuseable" do
      Slimerjs::Platform::OsX.should_not be_useable
    end

    it "reports the Win32 Platform as unuseable" do
      Slimerjs::Platform::Win32.should_not be_useable
    end
  end

  describe "on OS X" do
    before do
      Slimerjs::Platform.stub(:host_os).and_return('darwin')
      Slimerjs::Platform.stub(:architecture).and_return('x86_64')
    end

    it "reports the Darwin platform as useable" do
      Slimerjs::Platform::OsX.should be_useable
    end

    describe "without system install" do
      before(:each) { Slimerjs::Platform.stub(:system_slimerjs_version).and_return(nil) }

      it "returns the correct slimer js executable path for the platform" do
        Slimerjs.path.should =~ /darwin\/bin\/slimerjs$/
      end
    end

    describe "with system install" do
      before(:each) do
        Slimerjs::Platform.stub(:system_slimerjs_version).and_return(Slimerjs.version)
        Slimerjs::Platform.stub(:system_slimerjs_path).and_return('/tmp/path')
      end

      it "returns the correct slimer js executable path for the platform" do
        expect(Slimerjs.path).to be == '/tmp/path'
      end
    end

    it "reports the Linux32 Platform as unuseable" do
      Slimerjs::Platform::Linux32.should_not be_useable
    end

    it "reports the Linux64 platform as unuseable" do
      Slimerjs::Platform::Linux64.should_not be_useable
    end

    it "reports the Win32 Platform as unuseable" do
      Slimerjs::Platform::Win32.should_not be_useable
    end
  end

  describe "on Windows" do
    before do
      Slimerjs::Platform.stub(:host_os).and_return('mingw32')
      Slimerjs::Platform.stub(:architecture).and_return('i686')
    end

    describe "without system install" do
      before(:each) { Slimerjs::Platform.stub(:system_slimerjs_version).and_return(nil) }

      it "returns the correct slimer js executable path for the platform" do
        Slimerjs.path.should =~ /win32\/slimerjs.exe$/
      end
    end

    describe "with system install" do
      before(:each) do
        Slimerjs::Platform.stub(:system_slimerjs_version).and_return(Slimerjs.version)
        Slimerjs::Platform.stub(:system_slimerjs_path).and_return("#{ENV['TEMP']}/path")
      end

      it "returns the correct slimer js executable path for the platform" do
        expect(Slimerjs.path).to be == "#{ENV['TEMP']}/path"
      end
    end

    it "reports the Darwin platform as unuseable" do
      Slimerjs::Platform::OsX.should_not be_useable
    end

    it "reports the Linux32 Platform as unuseable" do
      Slimerjs::Platform::Linux32.should_not be_useable
    end

    it "reports the Linux64 platform as unuseable" do
      Slimerjs::Platform::Linux64.should_not be_useable
    end
  end

  describe 'on an unknown platform' do
    before do
      Slimerjs::Platform.stub(:host_os).and_return('foobar')
    end

    it "raises an UnknownPlatform error" do
      -> { Slimerjs.platform }.should raise_error(Slimerjs::UnknownPlatform)
    end
  end
end

require 'spec_helper'

describe Slimerjs do
  describe ".run" do
    it "runs slimerjs binary with the correct arguments" do
      script = File.expand_path('./spec/runner.js')
      result = Slimerjs.run(script, 'foo1', 'foo2')
      result.should eq("bar foo1\nbar foo2\n")
    end

    it "accepts a block that will get called for each line of output" do
      lines = []
      script = File.expand_path('./spec/runner.js')
      Slimerjs.run(script, 'foo1', 'foo2') { |line| lines << line }
      lines.should eq(["bar foo1\n", "bar foo2\n"])
    end
  end
end

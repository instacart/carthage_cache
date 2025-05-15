require "spec_helper"

describe CarthageCache::CartfileResolvedFile do

  let(:cartfile_resolved_path) { File.join(FIXTURE_PATH, "Cartfile.resolved") }
  let(:terminal) { MockTerminal.new(false) }
  let(:swift_version_resolver) { MockSwiftVersionResolver.new }
  subject(:cartfile_resolved) { CarthageCache::CartfileResolvedFile.new(cartfile_resolved_path, terminal, swift_version_resolver) }

  describe "#digest" do

    it "returns a digest of the Cartfile.resolved file content" do
      expect(cartfile_resolved.digest).to eq("ca1c63573fdcc6772ea9ee3844b1da01c774f31b659e420350151ef5ba74a29a")
    end

  end

  describe "#content" do

    it "returns the Cartfile.resolved file contet" do
      expect(cartfile_resolved.content).to eq(File.read(cartfile_resolved_path))
    end

  end

  describe "#frameworks" do

    it "returns a list of framewokrs name" do
      expect(cartfile_resolved.frameworks).to eq(["Neon", "Result"])
    end

  end

end

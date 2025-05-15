require "spec_helper"

describe CarthageCache::Project do

  let(:cache_dir_name) { "carthage_cache" }
  let(:terminal) { MockTerminal.new(false) }
  subject(:project) { CarthageCache::Project.new(FIXTURE_PATH, cache_dir_name, nil, terminal, TMP_PATH, MockSwiftVersionResolver.new) }

  describe "#archive_key" do

    it "returns the digest of the Cartfile.resolved file" do
      expect(project.archive_key).to eq("ca1c63573fdcc6772ea9ee3844b1da01c774f31b659e420350151ef5ba74a29a")
    end

  end

  describe "#archive_filename" do

    it "returns the name of the archive for the current Cartfile.resolved file" do
      expect(project.archive_filename).to eq("ca1c63573fdcc6772ea9ee3844b1da01c774f31b659e420350151ef5ba74a29a.tar.zst")
    end

  end

  describe "#archive_path" do
    
    it "returns the path of the archive for the current Cartfile.resolved file" do
      project = CarthageCache::Project.new(FIXTURE_PATH, cache_dir_name, "path", terminal, TMP_PATH, MockSwiftVersionResolver.new)
      expect(project.archive_path).to eq("path/ca1c63573fdcc6772ea9ee3844b1da01c774f31b659e420350151ef5ba74a29a.tar.zst")
    end

    it "returns the name of the archive for the current Cartfile.resolved file when path is nil" do
      expect(project.archive_path).to eq("ca1c63573fdcc6772ea9ee3844b1da01c774f31b659e420350151ef5ba74a29a.tar.zst")
    end

  end

  describe "#carthage_build_directory" do

    it "returns the project's Carthage build directory" do
      expect(project.carthage_build_directory).to eq(File.join(FIXTURE_PATH, "Carthage/Build"))
    end

  end

  describe "#tmpdir" do

    it "returns the project's temporary directory" do
      expect(project.tmpdir).to eq(File.join(TMP_PATH, cache_dir_name))
    end

  end

  describe "#all_frameworks" do

    it "returns all the project's dependencies" do
      expect(project.all_frameworks).to eq(["Neon", "Result"])
    end

  end

end

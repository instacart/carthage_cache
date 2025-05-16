require "spec_helper"

describe CarthageCache::Archiver do

  let(:executor) { double("executor") }
  let(:build_directory) { File.join(FIXTURE_PATH, "Carthage/Build") }
  let(:archive_path) { File.join(TMP_PATH, "archive.tar.zst") }
  subject(:archiver) { CarthageCache::Archiver.new(executor) }

  before(:each) do
    FileUtils.mkdir_p(build_directory)
    `zstd -d #{archive_path} -c | tar -C #{build_directory} -xf -`
  end

  after(:each) do
    FileUtils.rm_r(build_directory)
  end

  describe "#archive" do

    it "creates a zip file with the content of the project's 'Carthage/Build' directory" do
      expected_command = "tar -C #{build_directory} -cf - CarthageCache.lock | zstd -T0 -5 -o #{archive_path}"
      expect(executor).to receive(:execute).with(expected_command)
      archiver.archive(build_directory, archive_path)
    end

    context "when a filter block is passed" do

      it "filters platforms that don't match the filter" do
        expected_command = "tar -C #{build_directory} -cf -  | zstd -T0 -5 -o #{archive_path}"
        expect(executor).to receive(:execute).with(expected_command)
        archiver.archive(build_directory, archive_path) do |x|
          x == CarthageCache::CarthageCacheLock::LOCK_FILE_NAME || x == "iOS"
        end
      end

    end

  end

  describe "#unarchive" do

    it "unzips the archive file into the project's 'Carthage/Build' directory" do
      expected_command = "zstd -d #{archive_path} -c | tar -C #{build_directory} -xf -"
      expect(executor).to receive(:execute).with(expected_command)
      archiver.unarchive(archive_path, build_directory)
    end

  end

end

module CarthageCache

  class Archiver

    attr_reader :executor

    def initialize(executor = ShellCommandExecutor.new)
      @executor = executor
    end

    def archive(archive_path, destination_path, &filter_block)
      files = Dir.entries(archive_path).reject { |x| x.start_with?(".") }
      files = files.select(&filter_block) if filter_block
      files = files.sort_by(&:downcase)
      file_list = files.join(' ')
      executor.execute("tar -C #{archive_path} -cf - #{file_list} | zstd -T0 -19 -o #{File.expand_path(destination_path)}")
    end

    def unarchive(archive_path, destination_path)
      executor.execute("zstd -d #{archive_path} -c | tar -C #{destination_path} -xf -")
    end

  end

end

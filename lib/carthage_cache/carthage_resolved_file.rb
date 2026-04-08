require "digest"

module CarthageCache

  class CartfileResolvedFile

    class << self
      attr_writer :version
      def version
        @version ||= ''
      end
    end

    attr_reader :file_path
    attr_reader :terminal
    attr_reader :swift_version_resolver
    attr_reader :xcode_version

    def initialize(file_path, terminal = CarthageCache::Terminal.new, swift_version_resolver = SwiftVersionResolver.new, xcode_version: nil)
      @file_path = file_path
      @swift_version_resolver = swift_version_resolver
      @terminal = terminal
      @xcode_version = xcode_version
    end

    def digest
      @digest ||= generate_digest
    end

    def content
      @content ||= File.read(file_path)
    end

    def swift_version
      @swift_version ||= swift_version_resolver.swift_version
    end

    def xcodebuild_version
      @xcodebuild_version ||= `xcodebuild -version`.match(/Xcode ((\d+\.)?\d+\.\d+)/)[1]
    end

    def frameworks
      @frameworks ||= content.each_line.map { |line| extract_framework_name(line) }
    end

    private

      def generate_digest
        terminal.vputs "Generating carthage_cache archive digest using swift version '#{swift_version}' and " \
                      "the content of '#{file_path}'"
        generated_digest = Digest::SHA256.hexdigest(content + (xcode_version || xcodebuild_version) + "#{swift_version}" + self.class.version + 'zstd')
        terminal.vputs "Generated digest: #{generated_digest}"
        generated_digest
      end

      def extract_framework_name(cartfile_line)
        cartfile_line.split(" ")[1].split("/").last.gsub('"', "")
      end

  end

end

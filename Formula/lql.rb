class Lql < Formula
  desc "Linear Query Language — CLI for Linear optimized for LLM consumption"
  homepage "https://frr.dev"
  version "1.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/frr149/lql/releases/download/v1.2.2/lql-aarch64-apple-darwin.tar.xz"
      sha256 "4d217dcc7d6ae7c085fb1414fa9d4e19055b00f093222e963d67ac5d14329711"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frr149/lql/releases/download/v1.2.2/lql-x86_64-apple-darwin.tar.xz"
      sha256 "d7ce0d9efd767ca1c4eae2c1e2b601ff04136bb12b60000591e276c844523137"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/frr149/lql/releases/download/v1.2.2/lql-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5e91c342999cc75e0f2cd7ecf66281abc3446b678dc875b16c16ed17ab23b485"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frr149/lql/releases/download/v1.2.2/lql-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6d583bd8009b7485e10056b8c8b28fc2918516ddbea543eb9c6a5facc04588c9"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "lql" if OS.mac? && Hardware::CPU.arm?
    bin.install "lql" if OS.mac? && Hardware::CPU.intel?
    bin.install "lql" if OS.linux? && Hardware::CPU.arm?
    bin.install "lql" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

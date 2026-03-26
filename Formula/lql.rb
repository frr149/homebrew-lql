class Lql < Formula
  desc "Linear Query Language — CLI for Linear optimized for LLM consumption"
  homepage "https://frr.dev"
  version "1.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/frr149/lql/releases/download/v1.1.0/lql-aarch64-apple-darwin.tar.xz"
      sha256 "f1a87429880c16459a22e326760f2bf98a75b83579d4ad40ee04b41b2b43f79b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frr149/lql/releases/download/v1.1.0/lql-x86_64-apple-darwin.tar.xz"
      sha256 "e50364b7ca1a38eee472c78643cfdd5308e23e7ee55bd29b94d8612dd4e0cafa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/frr149/lql/releases/download/v1.1.0/lql-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "09e4eee325118552946fb0f6e494a7431e4ba02c98d931e882c03065b0f67d77"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frr149/lql/releases/download/v1.1.0/lql-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "052bfacb8fd928015dcfef0ba2b7724ab4fd5b8658c63457b342b4487a8ce627"
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

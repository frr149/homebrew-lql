class Lql < Formula
  desc "Linear Query Language — CLI for Linear optimized for LLM consumption"
  homepage "https://frr.dev"
  version "1.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/frr149/lql/releases/download/v1.2.3/lql-aarch64-apple-darwin.tar.xz"
      sha256 "2e6a80236d6e93a80b4b15b23039ea503e53d36a2e7d75568d4833927f2763f7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frr149/lql/releases/download/v1.2.3/lql-x86_64-apple-darwin.tar.xz"
      sha256 "aa09c1a6f9561ddb72098ffe249cab2a0f33460b978e6e0f4ef12e322784f63a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/frr149/lql/releases/download/v1.2.3/lql-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "26a45f2b5f37ee5469cf1ea3ccab27974d2caaea22faaf731a6c014accdeb3f5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frr149/lql/releases/download/v1.2.3/lql-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "55e1a6d27a98a473451ac61d220599ef369ec52ec18ed8ffef4c8383c7766ec0"
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

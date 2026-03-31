class Lql < Formula
  desc "Linear Query Language — CLI for Linear optimized for LLM consumption"
  homepage "https://frr.dev"
  version "1.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/frr149/lql/releases/download/v1.2.1/lql-aarch64-apple-darwin.tar.xz"
      sha256 "3659c09b8f6b68a941814c58efdb01e47d41fe5b17ed357727bb885ef7c1f0b0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frr149/lql/releases/download/v1.2.1/lql-x86_64-apple-darwin.tar.xz"
      sha256 "ed1ed7ff05e15752c96f3aa08c856d43fbae5eff3d383b9b9004010da0c729c1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/frr149/lql/releases/download/v1.2.1/lql-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "691faa6d9ae6a35e41b0596d1ac66874c844e92996d0c6ebf85d848a55ddf754"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frr149/lql/releases/download/v1.2.1/lql-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "300a748183d9d2cc2e317a45ce08d4deb55b2b9ee904b25f6110cdf040eda4c1"
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

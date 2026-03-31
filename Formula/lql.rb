class Lql < Formula
  desc "Linear Query Language — CLI for Linear optimized for LLM consumption"
  homepage "https://frr.dev"
  version "1.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/frr149/lql/releases/download/v1.2.0/lql-aarch64-apple-darwin.tar.xz"
      sha256 "e7c37d040255e19dfe5272f70aa0d827b073f133bcb76630f1c2b4ad648c31e1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frr149/lql/releases/download/v1.2.0/lql-x86_64-apple-darwin.tar.xz"
      sha256 "f4e68d4c4429ba37eb5d2ef9ca0ca694057cef3bb32460ebd643220f1eb12ee1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/frr149/lql/releases/download/v1.2.0/lql-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "179c76b8beef5453f4b6767333affe2e680b82350b194557b29dbb913bb2f4fd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/frr149/lql/releases/download/v1.2.0/lql-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8297efec9e45f5a247f08192c6de57200c4e2e77b9a98212b9a9588a9cb53039"
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

# agentctl macOS CLI (the `top --host` viewer / fleet tools).
# Binaries are served behind HTTP basic auth — Homebrew's curl honors ~/.netrc:
#   machine agentctl.srv.ajil.ch login agentctl password <PASSWORD>   (chmod 600 ~/.netrc)
# Install:  brew install muyajil/tap/agentctl    Upgrade:  brew upgrade agentctl
class Agentctl < Formula
  desc "Control plane for kernel-isolated AI agents (macOS CLI)"
  homepage "https://github.com/muyajil/agentctl"
  version "1.1.5"

  on_arm do
    url "https://agentctl.srv.ajil.ch/bin/agentctl-darwin-arm64"
    sha256 "429ac09d893e157d2098ee6063adf430c9e03cc26ddf42b371002b19d8e9e6fc"
  end
  on_intel do
    url "https://agentctl.srv.ajil.ch/bin/agentctl-darwin-amd64"
    sha256 "f38149ae0c3d3b86db809ce98c0516a640d735e9facfdf2ee131ce517de16328"
  end

  def install
    bin.install Dir["agentctl-darwin-*"].first => "agentctl"
  end

  test do
    assert_match "agentctl", shell_output("#{bin}/agentctl --version")
  end
end

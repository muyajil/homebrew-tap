# agentctl macOS CLI (the `top --host` viewer / fleet tools).
# Binaries are served behind HTTP basic auth — Homebrew's curl honors ~/.netrc:
#   machine agentctl.srv.ajil.ch login agentctl password <PASSWORD>   (chmod 600 ~/.netrc)
# Install:  brew install muyajil/tap/agentctl    Upgrade:  brew upgrade agentctl
class Agentctl < Formula
  desc "Control plane for kernel-isolated AI agents (macOS CLI)"
  homepage "https://github.com/muyajil/agentctl"
  version "1.1.4"

  on_arm do
    url "https://agentctl.srv.ajil.ch/bin/agentctl-darwin-arm64"
    sha256 "f1da26496ab1686232d363a2b1ff9869ad83b37fb8da1f73f6a2eeab1d8e2a11"
  end
  on_intel do
    url "https://agentctl.srv.ajil.ch/bin/agentctl-darwin-amd64"
    sha256 "6f6b8075ca9d96be86953a0feaa2391664c3020db67aa66410aa515d021031e2"
  end

  def install
    bin.install Dir["agentctl-darwin-*"].first => "agentctl"
  end

  test do
    assert_match "agentctl", shell_output("#{bin}/agentctl --version")
  end
end

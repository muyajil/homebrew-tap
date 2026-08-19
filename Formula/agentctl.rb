# agentctl macOS CLI. Binaries are served behind HTTP basic auth, so we use a
# tiny download strategy that tells Homebrew's curl to read ~/.netrc:
#   machine agentctl.srv.ajil.ch login agentctl password <PASSWORD>   (chmod 600 ~/.netrc)
# Install:  brew install muyajil/tap/agentctl    Upgrade:  brew upgrade agentctl
require "download_strategy"

class NetrcDownloadStrategy < CurlDownloadStrategy
  def _fetch(url:, resolved_url:, timeout:)
    curl_download resolved_url, "--netrc", to: temporary_path, timeout: timeout
  end
end

class Agentctl < Formula
  desc "Control plane for kernel-isolated AI agents (macOS CLI)"
  homepage "https://github.com/muyajil/agentctl"
  version "4.5.60"

  on_arm do
    url "https://agentctl.srv.ajil.ch/bin/agentctl-darwin-arm64", using: NetrcDownloadStrategy
    sha256 "a4a2d4e4178f460c6c939f0aab1615fda08b06420ed12ec1679d3288396524b4"
  end
  on_intel do
    url "https://agentctl.srv.ajil.ch/bin/agentctl-darwin-amd64", using: NetrcDownloadStrategy
    sha256 "b909831dd2b2b5beb1c23c1fbcd679ae9b4ad8f2b19b7f2a7f85ea88050f4c8b"
  end

  def install
    bin.install Dir["agentctl-darwin-*"].first => "agentctl"
  end

  test do
    assert_match "agentctl", shell_output("#{bin}/agentctl --version")
  end
end

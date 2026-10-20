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
  version "4.5.201"

  on_arm do
    url "https://agentctl.srv.ajil.ch/bin/agentctl-darwin-arm64", using: NetrcDownloadStrategy
    sha256 "857fa32a64120a6cf23ef81f5591ed1629833060aff5a709f80baada6ca6fa51"
  end
  on_intel do
    url "https://agentctl.srv.ajil.ch/bin/agentctl-darwin-amd64", using: NetrcDownloadStrategy
    sha256 "5fe4f26a18971060373bb7fdfbd371283fa3472b2db72c40cda1093579ed0a8b"
  end

  def install
    bin.install Dir["agentctl-darwin-*"].first => "agentctl"
  end

  test do
    assert_match "agentctl", shell_output("#{bin}/agentctl --version")
  end
end

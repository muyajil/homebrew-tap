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
  version "4.5.162"

  on_arm do
    url "https://agentctl.srv.ajil.ch/bin/agentctl-darwin-arm64", using: NetrcDownloadStrategy
    sha256 "6150f3115b8d477d9e93f793b5b5be96d625e7c52b877f6463707c2271150593"
  end
  on_intel do
    url "https://agentctl.srv.ajil.ch/bin/agentctl-darwin-amd64", using: NetrcDownloadStrategy
    sha256 "8a7f5af3279d50f5452e10b27b476cf8d35c3e1b11860d700c0974e0f7ed3390"
  end

  def install
    bin.install Dir["agentctl-darwin-*"].first => "agentctl"
  end

  test do
    assert_match "agentctl", shell_output("#{bin}/agentctl --version")
  end
end

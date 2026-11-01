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
  version "4.5.258"

  on_arm do
    url "https://agentctl.srv.ajil.ch/bin/agentctl-darwin-arm64", using: NetrcDownloadStrategy
    sha256 "4528f63fcc2ca19fb8d972c0cba24048bee5249aa035fe60f91054d4d91c313a"
  end
  on_intel do
    url "https://agentctl.srv.ajil.ch/bin/agentctl-darwin-amd64", using: NetrcDownloadStrategy
    sha256 "a2c8d9103fcb321aebdb8d4dccfc4378499dfaa5b9d72e1762964c85f15c9b14"
  end

  def install
    bin.install Dir["agentctl-darwin-*"].first => "agentctl"
  end

  test do
    assert_match "agentctl", shell_output("#{bin}/agentctl --version")
  end
end

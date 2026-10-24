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
  version "4.5.227"

  on_arm do
    url "https://agentctl.srv.ajil.ch/bin/agentctl-darwin-arm64", using: NetrcDownloadStrategy
    sha256 "cbaf82f5a9983423b6c8bda82603588f2c11e53fe329bb72c312caa2b7abd9f4"
  end
  on_intel do
    url "https://agentctl.srv.ajil.ch/bin/agentctl-darwin-amd64", using: NetrcDownloadStrategy
    sha256 "fd553a79b2d15ac1a680ace352a05a912efebb4158164dab0b90b6f7c1f707b0"
  end

  def install
    bin.install Dir["agentctl-darwin-*"].first => "agentctl"
  end

  test do
    assert_match "agentctl", shell_output("#{bin}/agentctl --version")
  end
end

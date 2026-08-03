cask "portaly" do
  version "0.1.1"
  sha256 "0717242f7ef9d4feb1024e64f61a33df79517c70aad662e482eaec7f4ca62347"

  url "https://github.com/hsandovaltides/portaly-releases/releases/download/v#{version}/Portaly_#{version}_aarch64.dmg"
  name "Portaly"
  desc "Unofficial GlobalProtect VPN client, built on OpenConnect"
  homepage "https://github.com/hsandovaltides/portaly-releases"

  # Only Apple Silicon builds are published today (the release workflow
  # only runs on the macos-latest/arm64 GitHub Actions runner).
  depends_on arch: :arm64
  depends_on macos: :monterey
  depends_on formula: "openconnect"

  app "Portaly.app"
  # Symlinks gpvpn-cli into Homebrew's bin dir -- without this it's only
  # reachable via the full path inside the .app bundle (Contents/MacOS/),
  # unlike gpvpn-agent/gpvpn-hipreport/gpvpn-auth, which are only ever
  # invoked internally by gpvpn-gui/gpvpn-agent themselves, never directly
  # by the user.
  binary "#{appdir}/Portaly.app/Contents/MacOS/gpvpn-cli"

  # Portaly.app is only ad-hoc signed (no paid Apple Developer ID, so it
  # can't be notarized). On Apple Silicon, Gatekeeper doesn't offer its
  # usual "unidentified developer, open anyway" bypass for ad-hoc-signed
  # code that carries the com.apple.quarantine flag Homebrew's download
  # sets -- it instead refuses to launch at all, reporting the app as
  # "damaged" (both from Finder and when exec'd directly, e.g. gpvpn-cli
  # from a terminal hangs indefinitely in the OS's signature-validation
  # path instead of failing). Stripping quarantine here is what a real
  # Developer ID + notarization would otherwise make unnecessary.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/Portaly.app"]
  end

  zap trash: [
    "~/Library/Application Support/com.tides.gpvpn",
    "~/Library/LaunchAgents/com.tides.gpvpn.plist",
    "~/Library/Saved Application State/com.tides.gpvpn.savedState",
  ]

  caveats <<~EOS
    Portaly runs a privileged helper (gpvpn-agent) via osascript when you
    connect, prompting for your macOS password each time -- this is
    expected, not an error.

    gpvpn-cli is on your PATH as `gpvpn-cli` once this Cask is installed.
  EOS
end

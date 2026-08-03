cask "portaly" do
  version "0.1.1"
  sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"

  url "https://github.com/hsandovaltides/GlobalProtect-openconnect/releases/download/v#{version}/Portaly_#{version}_aarch64.dmg"
  name "Portaly"
  desc "Unofficial GlobalProtect VPN client, built on OpenConnect"
  homepage "https://github.com/hsandovaltides/GlobalProtect-openconnect"

  # Only Apple Silicon builds are published today (the release workflow
  # only runs on the macos-latest/arm64 GitHub Actions runner).
  depends_on arch: :arm64
  depends_on macos: ">= :monterey"
  depends_on formula: "openconnect"

  app "Portaly.app"

  # Symlinks gpvpn-cli into Homebrew's bin dir -- without this it's only
  # reachable via the full path inside the .app bundle (Contents/MacOS/),
  # unlike gpvpn-agent/gpvpn-hipreport/gpvpn-auth, which are only ever
  # invoked internally by gpvpn-gui/gpvpn-agent themselves, never directly
  # by the user.
  binary "#{appdir}/Portaly.app/Contents/MacOS/gpvpn-cli"

  zap trash: [
    "~/Library/LaunchAgents/com.tides.gpvpn.plist",
    "~/Library/Application Support/com.tides.gpvpn",
    "~/Library/Saved Application State/com.tides.gpvpn.savedState",
  ]

  caveats <<~EOS
    Portaly runs a privileged helper (gpvpn-agent) via osascript when you
    connect, prompting for your macOS password each time -- this is
    expected, not an error.

    gpvpn-cli is on your PATH as `gpvpn-cli` once this Cask is installed.
  EOS
end

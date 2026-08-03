# homebrew-portaly

Homebrew Cask tap for [Portaly](https://github.com/hsandovaltides/GlobalProtect-openconnect),
an unofficial GlobalProtect VPN client built on OpenConnect. Not affiliated
with Palo Alto Networks.

## Install

```bash
brew install --cask hsandovaltides/portaly/portaly
```

This also installs `openconnect` automatically if it isn't already
present, and puts `gpvpn-cli` on your `$PATH`.

Apple Silicon only for now (the release only publishes an `aarch64` build).

## Upgrade

```bash
brew upgrade --cask portaly
```

## Uninstall

```bash
brew uninstall --cask portaly
# to also remove saved settings/LaunchAgent:
brew uninstall --cask --zap portaly
```

#!/bin/sh
# Rebuilds windows-11_0.0.0_utm_arm64.box from the chunks in parts/
set -e
cat parts/win11.box.part* > windows-11_0.0.0_utm_arm64.box
ls -l windows-11_0.0.0_utm_arm64.box
echo "expected size: 6004430512 bytes"
echo "expected sha256: a0b78ed883dc8a8510f3e4fd30d2d5c6b9b4edb5c68852abb86927556b9460ad"
(sha256sum windows-11_0.0.0_utm_arm64.box 2>/dev/null || shasum -a 256 windows-11_0.0.0_utm_arm64.box)

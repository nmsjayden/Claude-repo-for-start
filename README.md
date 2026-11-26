# utm/windows-11 v0.0.0 (utm, arm64) box, split into chunks

Unmodified copy of the Vagrant box `utm/windows-11` v0.0.0, split into 95 MiB
pieces in `parts/` (`win11.box.part00` ... in order).

Rebuild:

    git clone --depth 1 -b claude/serene-heisenberg-kha6tf https://github.com/nmsjayden/Claude-repo-for-start
    cd Claude-repo-for-start && ./join.sh
    tar -xf windows-11_0.0.0_utm_arm64.box

Expected:

- `.box`: 6,004,430,512 bytes, sha256 `a0b78ed883dc8a8510f3e4fd30d2d5c6b9b4edb5c68852abb86927556b9460ad`
- `box.utm/Data/B32C9712-8AD6-49EC-A578-8CFE40C1F9FA.qcow2`: 9,283,436,544 bytes,
  sha256 `90470f309b39f05352332b5aa1b98f6b989f0012478f1d5235c6ebe518a6ae6d`

Per-chunk hashes are in `parts/SHA256SUMS`.

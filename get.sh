#!/bin/sh
# Downloads the box chunks (resumable), unpacks box.utm in the current folder,
# and swaps in the iPhone-adjusted config so UTM on iOS can import it.
# Safe to re-run: finished chunks are skipped, partial ones resume, and if the
# disk is already unpacked at full size only the config is patched.
R=https://raw.githubusercontent.com/nmsjayden/Claude-repo-for-start/claude/serene-heisenberg-kha6tf
Q=Data/B32C9712-8AD6-49EC-A578-8CFE40C1F9FA.qcow2
QSIZE=9283436544
size() { if [ -f "$1" ]; then wc -c < "$1" | tr -d ' '; else echo 0; fi; }

[ -d box ] && [ ! -d box.utm ] && mv box box.utm

if [ "$(size "box.utm/$Q")" = "$QSIZE" ]; then
  echo "disk already unpacked at full size, skipping download"
else
  mkdir -p parts
  for a in 0 1 2 3 4 5 6; do for b in 0 1 2 3 4 5 6 7 8 9; do
    n=$a$b
    [ "$n" -gt 60 ] && break
    want=99614720; [ "$n" = 60 ] && want=27547312
    f=parts/win11.box.part$n
    if [ "$(size "$f")" != "$want" ]; then
      echo "chunk $n of 60"
      curl -fL --retry 5 -C - -o "$f" "$R/parts/win11.box.part$n" || { echo "chunk $n failed - run again to resume"; exit 1; }
    fi
  done; done
  echo "all chunks present, unpacking (this takes a while)..."
  cat parts/win11.box.part* | tar -xzf - || { echo "unpack failed"; exit 1; }
  if [ "$(size "box.utm/$Q")" != "$QSIZE" ]; then
    echo "qcow2 is the wrong size after unpacking - check free space and run again"; exit 1
  fi
fi

echo "patching config for iPhone..."
curl -fsL --retry 5 -o config-ios.tmp "$R/config-ios.plist" || { rm -f config-ios.tmp; echo "config download failed - run again"; exit 1; }
if [ "$(size config-ios.tmp)" != 2801 ]; then rm -f config-ios.tmp; echo "config download incomplete - run again"; exit 1; fi
[ -f box.utm/config.plist ] && [ ! -f config-mac.plist.bak ] && cp box.utm/config.plist config-mac.plist.bak
mv config-ios.tmp box.utm/config.plist

ls -l box.utm box.utm/Data
echo "DONE - box.utm is ready to open in UTM. You can delete the parts folder (rm -r parts)."

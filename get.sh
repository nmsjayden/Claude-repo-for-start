#!/bin/sh
# Downloads the box chunks (resumable) and unpacks box.utm in the current folder.
# Safe to re-run: finished chunks are skipped, partial ones resume.
B=https://raw.githubusercontent.com/nmsjayden/Claude-repo-for-start/claude/serene-heisenberg-kha6tf/parts
mkdir -p parts
for a in 0 1 2 3 4 5 6; do for b in 0 1 2 3 4 5 6 7 8 9; do
  n=$a$b
  [ "$n" -gt 60 ] && break
  want=99614720; [ "$n" = 60 ] && want=27547312
  f=parts/win11.box.part$n
  have=0; [ -f "$f" ] && have=$(wc -c < "$f" | tr -d ' ')
  if [ "$have" != "$want" ]; then
    echo "chunk $n of 60"
    curl -fL --retry 5 -C - -o "$f" "$B/win11.box.part$n" || { echo "chunk $n failed - run again to resume"; exit 1; }
  fi
done; done
echo "all chunks present, unpacking (this takes a while)..."
cat parts/win11.box.part* | tar -xzf - || { echo "unpack failed"; exit 1; }
ls -l box.utm/Data
echo "qcow2 should be 9283436544 bytes. If it is, you can delete the parts folder."

# Checks the unpacked VM files against the known-good sizes and SHA-256 hashes.
import hashlib, os, sys
Q = "B32C9712-8AD6-49EC-A578-8CFE40C1F9FA.qcow2"
WANT = [
    ("Data/" + Q, 9283436544, "90470f309b39f05352332b5aa1b98f6b989f0012478f1d5235c6ebe518a6ae6d"),
    ("Data/efi_vars.fd", 655360, "809b3b980ba77d213ac27ad1f6654e74abef60363da15d5499b73924a21ac806"),
]
root = next((d for d in sys.argv[1:] + ["box.utm", "box"] if os.path.isdir(d)), None)
if not root:
    sys.exit("No box.utm or box folder here. cd to where you ran get.sh, or pass the folder name.")
IOS = (2801, "3ee078ccb988e9b2895afba97852f0c416c5a0cfb02cf7d6c41421b208ac9481")
bad = 0
for rel, size, sha in WANT:
    p = os.path.join(root, rel)
    if not os.path.isfile(p):
        print("MISSING ", rel); bad += 1; continue
    got = os.path.getsize(p)
    if got != size:
        print("BAD SIZE", rel, got, "expected", size); bad += 1; continue
    h = hashlib.sha256()
    with open(p, "rb") as f:
        done = 0
        for blk in iter(lambda: f.read(8 << 20), b""):
            h.update(blk); done += len(blk)
            if size > (1 << 30):
                print("\r  hashing %s %d%%" % (rel[-12:], done * 100 // size), end="", flush=True)
    if size > (1 << 30): print()
    if h.hexdigest() != sha:
        print("BAD HASH", rel); bad += 1
    else:
        print("OK      ", rel, size, "bytes")
p = os.path.join(root, "config.plist")
if not os.path.isfile(p):
    print("MISSING  config.plist"); bad += 1
else:
    d = hashlib.sha256(open(p, "rb").read()).hexdigest()
    if d == IOS[1]: print("OK       config.plist (iPhone version)")
    elif d == "6ab099f8d11f15d8404c57ad244211b6d7602cf7087e2c195f8f43007f75d323": print("NOTE     config.plist is still the Mac version - it will not import on iPhone")
    else: print("BAD HASH config.plist"); bad += 1
print("ALL GOOD - disk is identical to the original box" if not bad else "%d PROBLEM(S) - run sh get.sh again" % bad)

#!/usr/bin/env python3
"""Merge compiler-extracted localization keys into Localizable.xcstrings.

Xcode only extracts strings into a catalog that lives in the same target, and
most UI strings live in the AmgiFeatures / AmgiUI packages while the catalog
lives in the app. So we let the compiler do the extraction (it knows exactly
which literals became LocalizedStringKey / String(localized:), including the
%lld / %@ shape of interpolations) and merge its output here.

Usage:
    # 1. build once with extraction turned on
    xcodebuild ... -derivedDataPath build SWIFT_EMIT_LOC_STRINGS=YES build
    # 2. merge
    ./scripts/sync-strings.py            # add new keys, keep translations
    ./scripts/sync-strings.py --report   # also list untranslated keys

Existing translations are never touched. Keys no longer produced by the
compiler are kept but marked "stale" so they are easy to spot and prune.
"""

import argparse
import glob
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CATALOG = os.path.join(ROOT, "AmgiApp", "Resources", "Localizable.xcstrings")
DERIVED = os.path.join(ROOT, "build", "Build", "Intermediates.noindex")
TARGET_LANGS = ["zh-Hans"]


def extracted_keys():
    files = [
        f
        for f in glob.glob(os.path.join(DERIVED, "**", "*.stringsdata"), recursive=True)
        if "ExtractedAppShortcuts" not in f
    ]
    if not files:
        sys.exit(
            "No .stringsdata found under build/. Build with "
            "SWIFT_EMIT_LOC_STRINGS=YES and -derivedDataPath build first."
        )
    keys = {}
    for path in files:
        with open(path) as fh:
            data = json.load(fh)
        # Third-party packages checked out under build/ ship their own strings.
        if "/SourcePackages/" in data.get("source", ""):
            continue
        for entry in data.get("tables", {}).get("Localizable", []):
            keys.setdefault(entry["key"], entry.get("comment"))
    return keys


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--report", action="store_true", help="list untranslated keys")
    args = parser.parse_args()

    with open(CATALOG) as fh:
        catalog = json.load(fh)
    strings = catalog.setdefault("strings", {})
    keys = extracted_keys()

    added = 0
    for key, comment in keys.items():
        entry = strings.get(key)
        if entry is None:
            entry = strings[key] = {}
            added += 1
        entry["extractionState"] = "manual"
        if comment and "comment" not in entry:
            entry["comment"] = comment

    stale = 0
    for key, entry in strings.items():
        if key not in keys:
            entry["extractionState"] = "stale"
            stale += 1

    with open(CATALOG, "w") as fh:
        json.dump(catalog, fh, ensure_ascii=False, indent=2, sort_keys=True, separators=(",", " : "))
        fh.write("\n")

    total = len(strings)
    for lang in TARGET_LANGS:
        missing = sorted(
            k for k, e in strings.items()
            if e.get("extractionState") != "stale" and lang not in e.get("localizations", {})
        )
        done = total - stale - len(missing)
        print(f"{lang}: {done}/{total - stale} translated")
        if args.report:
            for k in missing:
                print(f"  {k}")
    print(f"added {added} new keys, {stale} stale")


if __name__ == "__main__":
    main()

#!/bin/bash
# Lists string literals in the app's Swift sources that may be SF Symbol names: every dotted
# lowercase name ("eye.slash"), and single words that are returned, or sit on lines that talk about
# symbols or icons ("trash").
set -euo pipefail
cd "$(dirname "$0")/.."
find Compositor -name '*.swift' -print0 | xargs -0 perl -ne '
  while (/"([a-z][a-z0-9]*(?:\.[a-z0-9]+)+)"/g) { print "$1\n" }
  while (/(?:return|case [^:"]*:)\s*"([a-z][a-z0-9]*)"/g) { print "$1\n" }
  if (/systemName|systemImage|systemSymbolName|symbol|Symbol|badge|icon|Icon/) {
    while (/"([a-z][a-z0-9]*)"/g) { print "$1\n" }
  }' | sort -u

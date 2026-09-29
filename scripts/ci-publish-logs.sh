#!/bin/bash
# Copies a job's logs into the build-logs branch under <name>/, so a run can be read with plain git.
# Usage: scripts/ci-publish-logs.sh <name> <logs-dir>   (needs GH_TOKEN and GITHUB_REPOSITORY)
set -uo pipefail
name="$1"
source_dir="$(cd "$2" && pwd)"
url="https://x-access-token:${GH_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
work="${RUNNER_TEMP:-/tmp}/build-logs-$name"
rm -rf "$work"

for attempt in 1 2 3 4 5; do
  rm -rf "$work"
  if ! git clone -q --depth 1 --branch build-logs "$url" "$work" 2>/dev/null; then
    mkdir -p "$work" && git -C "$work" init -q -b build-logs && git -C "$work" remote add origin "$url"
  fi
  cd "$work"
  git config user.name "github-actions[bot]"
  git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
  rm -rf "$name" && mkdir -p "$name"
  cp -R "$source_dir"/. "$name"/
  printf 'run %s attempt %s\ncommit %s\njob %s\n' "${GITHUB_RUN_ID:-}" "${GITHUB_RUN_ATTEMPT:-}" "${GITHUB_SHA:-}" "$name" > "$name/RUN.txt"
  git add -A
  git commit -q -m "logs: $name for ${GITHUB_SHA:0:7} (run ${GITHUB_RUN_ID:-})" || exit 0
  if git push -q origin build-logs; then exit 0; fi
  sleep $((attempt * 3))
done
echo "could not publish logs" >&2
exit 0

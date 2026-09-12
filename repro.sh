#!/usr/bin/env bash
set -euo pipefail

if ! command -v omp >/dev/null 2>&1; then
  printf 'error: omp is not on PATH\n' >&2
  exit 2
fi

repo_dir="$(cd "$(dirname "$0")" && pwd)"
test_root="$(mktemp -d)"
trap 'rm -rf "$test_root"' EXIT
mkdir "$test_root/worktree"

set +e
output="$({
  omp \
    --cwd "$test_root/worktree" \
    --extension "$repo_dir/delete-cwd.ts" \
    --no-extensions \
    --no-session \
    --no-rules \
    --no-skills \
    --no-lsp \
    --print \
    "Do nothing"
} 2>&1)"
status=$?
set -e

printf '%s\n' "$output"
printf '\nexit status: %s\n' "$status"

if [[ $status -ne 0 && "$output" == *"process.cwd failed"* && "$output" == *"uv_cwd"* ]]; then
  printf '\nReproduced: OMP terminated after its working directory disappeared.\n'
  exit 0
fi

printf '\nDid not reproduce the expected deleted-cwd crash.\n' >&2
exit 1

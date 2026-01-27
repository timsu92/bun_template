#!/bin/bash
# exits if sub-processes fail, or if an unset variable is attempted to be used, or if there's a pipe failure
set -euo pipefail
script_dir="$(dirname "${BASH_SOURCE[0]:-$0}")"

# configure git to use bun for lockb diffs
git config --local diff.lockb.textconv bun
git config --local diff.lockb.binary true

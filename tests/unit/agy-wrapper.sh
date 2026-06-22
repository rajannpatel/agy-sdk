#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

install_wrapper() {
  cp "$ROOT/bin/agy" "$TMPDIR/agy"
  chmod +x "$TMPDIR/agy"

  cat >"$TMPDIR/agy-bin" <<'EOF'
#!/usr/bin/env bash
printf '<%s>\n' "$@"
EOF
  chmod +x "$TMPDIR/agy-bin"
}

run_wrapper() {
  "$TMPDIR/agy" "$@"
}

assert_output() {
  local expected=$1
  shift

  local actual
  actual=$(run_wrapper "$@")
  if [[ "$actual" != "$expected" ]]; then
    printf 'Expected:\n%s\n\nActual:\n%s\n' "$expected" "$actual" >&2
    return 1
  fi
}

install_wrapper

assert_output '<--no-sandbox>' 
assert_output '<--no-sandbox>
<-p>
<install>' -p install
assert_output '<--no-sandbox>
<--prompt=install>' --prompt=install
assert_output '<--no-sandbox>
<--model>
<install>
<-p>
<help>' --model install -p help
assert_output '<install>' install
assert_output '<models>' models
assert_output '<plugin>
<install>' plugin install
assert_output '<--sandbox>
<-p>
<install>' --sandbox -p install
assert_output '<--no-sandbox>
<-p>
<install>' --no-sandbox -p install
assert_output '<--version>' --version
assert_output '<--help>' --help

printf 'agy wrapper tests passed\n'

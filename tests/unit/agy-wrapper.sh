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
if [[ -n "${ELECTRON_EXTRA_LAUNCH_ARGS:-}" ]]; then
  printf '<ENV:ELECTRON_EXTRA_LAUNCH_ARGS=%s>\n' "$ELECTRON_EXTRA_LAUNCH_ARGS"
fi
[[ $# -gt 0 ]] && printf '<%s>\n' "$@" || true
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

# Bare TUI invocation: --no-sandbox goes via ELECTRON_EXTRA_LAUNCH_ARGS, not argv
assert_output '<ENV:ELECTRON_EXTRA_LAUNCH_ARGS=--no-sandbox>'

# Non-interactive flags (-p, --prompt, -i, --prompt-interactive) do not trigger injection
assert_output '<-p>
<install>' -p install
assert_output '<--prompt=install>' --prompt=install
assert_output '<--model>
<install>
<-p>
<help>' --model install -p help

# Subcommands: no injection
assert_output '<install>' install
assert_output '<models>' models
assert_output '<plugin>
<install>' plugin install

# Explicit --sandbox: suppresses env var injection
assert_output '<--sandbox>
<-p>
<install>' --sandbox -p install

# Explicit --no-sandbox: suppresses env var injection (user passed it themselves)
assert_output '<--no-sandbox>
<-p>
<install>' --no-sandbox -p install

# Utility flags: no injection
assert_output '<--version>' --version
assert_output '<--help>' --help

printf 'agy wrapper tests passed\n'

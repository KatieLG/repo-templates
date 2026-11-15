#!/usr/bin/env bash
# Generates each project type, and the desktop type with each add-on, into a temp directory and
# runs `uv sync && make check` in it. For desktop it also checks that the web templates were
# copied byte-for-byte and that `make check` didn't need to reformat them.
#
# Usage: scripts/test-templates.sh [case]   e.g. scripts/test-templates.sh desktop-core
set -euo pipefail

repo="$(cd "$(dirname "$0")/.." && pwd)"
only="${1:-}"
out="$(mktemp -d "${TMPDIR:-/tmp}/test-templates.XXXXXX")"

desktop="-d project_type=desktop -d project_name=demo_app -d project_description=Test"
cases=(
  "library|-d project_type=library -d project_name=lib_pkg -d project_description=Test -d include_config_setup=true -d config_type=single"
  "library-cli|-d project_type=library -d project_name=lib_pkg -d project_description=Test -d include_cli=true -d alias_name=lp -d include_config_setup=true -d config_type=multiple"
  "fastapi|-d project_type=fastapi -d project_name=app -d project_description=Test -d include_config_setup=true -d config_type=single"
  "desktop-core|$desktop"
  "desktop-topbar|$desktop -d navigation=topbar"
  "desktop-charts|$desktop -d include_charts=true"
  "desktop-database|$desktop -d include_database=true"
  "desktop-all|$desktop -d include_charts=true -d include_database=true"
)

# Fails if any generated web template differs from its source in the template repo
check_templates_verbatim() {
  local dir="$1" src="$repo/desktop/src/{{project_name}}/web/templates"
  local generated="$dir/src/demo_app/web/templates"
  while IFS= read -r file; do
    local rel="${file#"$generated"/}" name source matched=""
    name="$(basename "$rel")"
    # Several sources can generate the same file (e.g. each navigation's layout.html)
    while IFS= read -r source; do
      cmp -s "$file" "$source" && matched=1
    done < <(find "$src/$(dirname "$rel")" -maxdepth 1 -type f \( -name "$name" -o -name "*%}$name{%*" \))
    if [[ -z "$matched" ]]; then
      echo "Template not copied verbatim: $rel"
      return 1
    fi
  done < <(find "$generated" -type f)
}

failed=()
for entry in "${cases[@]}"; do
  name="${entry%%|*}"
  args="${entry#*|}"
  [[ -n "$only" && "$only" != "$name" ]] && continue
  echo "=== $name"
  dir="$out/$name"
  # HEAD rather than the latest tag, so uncommitted changes are included
  # shellcheck disable=SC2086 # args are deliberately split
  if ! copier copy --quiet --defaults --overwrite --vcs-ref HEAD $args "$repo" "$dir" 2>/dev/null; then
    failed+=("$name (copier)")
    continue
  fi
  if ! (cd "$dir" && uv sync --quiet && make check); then
    failed+=("$name (make check)")
    continue
  fi
  if [[ "$name" == desktop-* ]] && ! check_templates_verbatim "$dir"; then
    failed+=("$name (templates)")
  fi
done

echo
echo "Generated projects are in $out"
if ((${#failed[@]})); then
  printf 'Failed: %s\n' "${failed[@]}"
  exit 1
fi
echo "All passed"

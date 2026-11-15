.PHONY: vendor-update test-templates

# Frontend libraries vendored into the desktop template. Bump a version here, run
# `make vendor-update`, and update the versions table in desktop/README.md.jinja.
DAISYUI_VERSION := 5.8.0
TAILWIND_VERSION := 4.3.5
ALPINE_VERSION := 3.17.5
ECHARTS_VERSION := 6.1.0

cdn := https://cdn.jsdelivr.net/npm
vendor := desktop/src/{{project_name}}/web/vendor

vendor-update:
	curl -fsSL -o "$(vendor)/daisyui.css" $(cdn)/daisyui@$(DAISYUI_VERSION)/daisyui.css
	curl -fsSL -o "$(vendor)/themes.css" $(cdn)/daisyui@$(DAISYUI_VERSION)/themes.css
	curl -fsSL -o "$(vendor)/tailwind-browser.js" $(cdn)/@tailwindcss/browser@$(TAILWIND_VERSION)/dist/index.global.js
	curl -fsSL -o "$(vendor)/alpine.min.js" $(cdn)/alpinejs@$(ALPINE_VERSION)/dist/cdn.min.js
	curl -fsSL -o "$(vendor)/{% if include_charts %}echarts.min.js{% endif %}" $(cdn)/echarts@$(ECHARTS_VERSION)/dist/echarts.min.js

# Generates each project type (and each desktop add-on) into a temp directory and runs
# `uv sync && make check` in it. Pass `only=<name>` to run a single case, e.g. only=desktop-core.
test-templates:
	./scripts/test-templates.sh $(only)

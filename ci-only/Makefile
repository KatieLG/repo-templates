.PHONY: lint format test check bump

bump := "patch"

lint:
	uv run ruff check
	uv run ty check

format:
	uv run ruff format
	uv run ruff check --fix

test:
	uv run pytest

check: format lint test

bump:
	uv version --bump $(bump)
	git add pyproject.toml
	git add uv.lock
	git commit -m "bump: v$$(uv version --short)"

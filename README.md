# Repo templates

A [copier](https://copier.readthedocs.io/en/stable/) template for python projects. Supports 3 options for `project_type`.

## Project types

- `fastapi` — a [FastAPI](https://fastapi.tiangolo.com/) app with optional Jinja2 HTML templates and Tailwind CSS
- `library` — a Python library managed with [uv](https://docs.astral.sh/uv/), with an optional [typer](https://typer.tiangolo.com/) CLI entrypoint
- `ci-only` — just a Makefile and GitHub Actions CI workflow, to add to an existing project

All share:

- ruff formatting and linting
- Makefile for standard commands
- Basic ci that runs the formatter with auto-push
- an optional Python version test matrix
- An optional PyPI publish job triggered on version tags.

## How to use

- Install [copier](https://copier.readthedocs.io/en/stable/)
- Run the following and answer the interactive prompts:
  ```bash
  copier copy https://github.com/KatieLG/repo-templates.git <target-path>
  ```
- Each generated repo has a README including setup steps

## Layout

Each project type lives in its own subdirectory (selected via `_subdirectory` in `copier.yml`). Files identical across projects live in `shared/` and are included in the relevant jinja templates.

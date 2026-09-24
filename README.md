# repo-templates

A [copier](https://copier.readthedocs.io/en/stable/) template for Python projects.

## Usage

```bash
copier copy gh:KatieLG/repo-templates <target-path>
```

## Project types

The first prompt is `project_type` and decides which other prompts and options follow.

| Type      | Output                                                                                                              |
| --------- | ------------------------------------------------------------------------------------------------------------------- |
| `fastapi` | A FastAPI app. Optionally includes Jinja2 templates + static files and/or Tailwind CSS.                             |
| `library` | A Python package with a `src/` layout. Optionally includes tests and/or a [typer](https://typer.tiangolo.com/) CLI. |
| `ci-only` | A Makefile and GitHub Actions workflow, for adding to an existing project.                                          |

`fastapi` and `library` can also include [pydantic-settings](https://docs.pydantic.dev/latest/concepts/pydantic_settings/) config with a single env file or multiple (dev, staging, prod).

## Tooling

- [uv](https://docs.astral.sh/uv/) for dependencies, Python 3.13 by default
- [ruff](https://docs.astral.sh/ruff/) for formatting and linting
- [ty](https://docs.astral.sh/ty/) for type checking
- [pytest](https://pypi.org/project/pytest/) for tests
- Makefile: `format`, `lint`, `test`, `check`, `bump`

## CI (optional)

GitHub Actions workflow with lint and test jobs on push and PR to `main`. Optional extras:

- Auto-format and commit the result
- Test matrix across Python 3.10–3.13
- Publish to PyPI on `v*` tags

## Layout

Each project type is a subdirectory, selected with `_subdirectory` in `copier.yml`. Files shared across types live in `shared/` and are included from the jinja templates.

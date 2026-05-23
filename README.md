# Repo templates

Various templates using [copier](https://copier.readthedocs.io/en/stable/) 

## Available templates

- [python-fastapi-template](/templates/python-fastapi-template)
  - template for spinning up a [FastAPI](https://fastapi.tiangolo.com/) app with optional Jinja2 HTML templates and Tailwind CSS
- [python-cli-template](/templates/python-cli-template)
  - template for spinning up a python cli with [typer](https://typer.tiangolo.com/)
- [python-ci-template](/templates/python-ci-template)
  - template for a standard Makefile for uv managed python projects, with optional GitHub Actions CI workflow

## How to use

- Install copier as per the copier docs
- Copy the template you want with
  ```bash
  copier copy /templates/<template-of-choice> <target-path>
  ```
  and follow the interactive prompts
- each repo then has a setup command, e.g. for a python project, cd in and run `uv sync`

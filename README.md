# Repo templates

Various templates using [copier](https://copier.readthedocs.io/en/stable/) 

## Available templates

- [python-cli-template](/templates/python-cli-template)
  - template for spinning up a python cli with [typer](https://typer.tiangolo.com/)
- [github-ci-uv](/templates/github-ci-uv)
  - template for basic github action to run linting, (optionally formatting) and tests for a uv managed python project
  - assumes the use of a makefile for lint format and test commands
- [python-uv-makefile](/templates/python-uv-makefile)
  - template for standard makefile for uv managed python projects

## How to use

- Install copier as per the copier docs
- Copy the template you want with
  ```bash
  copier copy /templates/<template-of-choice> <target-path>
  ```
  and follow the interactive prompts
- each repo then has a setup command, e.g. for a python project, cd in and run `uv sync`

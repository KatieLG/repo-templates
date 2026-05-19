"""Shared console output utilities."""

import sys
from collections.abc import Callable
from functools import wraps
from typing import Any

from rich.console import Console
from rich.markdown import Markdown

_console = Console()


def is_interactive() -> bool:
    """Check if output is going to a terminal (not piped/redirected)."""
    return sys.stdout.isatty()


def interactive_only[**P, R](func: Callable[P, R]) -> Callable[P, R | None]:
    """Suppress output when stdout is not a TTY."""

    @wraps(func)
    def wrapper(*args: P.args, **kwargs: P.kwargs) -> R | None:
        if is_interactive():
            return func(*args, **kwargs)
        return None

    return wrapper


@interactive_only
def error(message: str) -> None:
    _console.print(f"[red]{message}[/red]")


@interactive_only
def success(message: str) -> None:
    _console.print(f"[green]{message}[/green]")


@interactive_only
def info(message: str) -> None:
    _console.print(message)


def markdown(message: str) -> None:
    formatted = Markdown(message) if is_interactive() else message
    _console.print(formatted)


@interactive_only
def warning(message: str) -> None:
    _console.print(f"[yellow]{message}[/yellow]")


def print(*args: Any, **kwargs: Any) -> None:  # noqa: ANN401
    _console.print(*args, **kwargs)


def print_json(json: Any, **kwargs: Any) -> None:  # noqa: ANN401
    _console.print_json(json, **kwargs)

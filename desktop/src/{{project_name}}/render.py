from pathlib import Path

from jinja2 import Environment, FileSystemLoader, StrictUndefined

WEB = Path(__file__).parent / "web"
OUTPUT = WEB / ".index.html"
# index.html loads these itself: Tailwind first, Alpine last
FIXED_SCRIPTS = {"tailwind-browser.js", "alpine.min.js"}


def vendor_scripts() -> list[str]:
    """Every other script in web/vendor/, so a library loads just by adding it there."""
    paths = sorted((WEB / "vendor").glob("*.js"))
    return [p.name for p in paths if p.name not in FIXED_SCRIPTS]


def render_index(app_title: str, default_theme: str, output: Path = OUTPUT) -> Path:
    """Renders the templates into one page, next to the css/js/vendor folders it links to."""
    env = Environment(
        loader=FileSystemLoader(WEB / "templates"),
        undefined=StrictUndefined,
        autoescape=False,
    )
    page = env.get_template("index.html").render(
        app_title=app_title,
        default_theme=default_theme,
        vendor_scripts=vendor_scripts(),
    )
    output.write_text(page)
    return output

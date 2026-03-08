#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = [
#   "requests>=2.32.0",
# ]
# ///
"""
Download remote images referenced in a Markdown file and rewrite the Markdown
to use local image paths.

Features:
- Finds image URLs in both HTML <img src="..."> tags and Markdown ![](...) syntax
- Downloads all remote images into a local images/ directory
- Rewrites the existing Markdown file in place by default
- Avoids duplicate downloads for repeated URLs
- Generates collision-safe filenames
- Preserves query-less local paths like images/foo.jpg

Example:
    python localize_md_images.py CodeEvolve_2510.14150v3.md
    python localize_md_images.py CodeEvolve_2510.14150v3.md --image-dir figures
    python localize_md_images.py CodeEvolve_2510.14150v3.md --output paper_local.md
"""

from __future__ import annotations

import argparse
import hashlib
import mimetypes
import re
import sys
from pathlib import Path
from typing import Dict
from urllib.parse import urlparse, unquote

import requests


HTML_IMG_RE = re.compile(
    r'(<img\b[^>]*\bsrc=["\'])(https?://[^"\']+)(["\'][^>]*>)',
    flags=re.IGNORECASE,
)

MD_IMG_RE = re.compile(
    r'(!\[[^\]]*\]\()'
    r'(https?://[^)\s]+)'
    r'(\))',
    flags=re.IGNORECASE,
)


def sanitize_filename(name: str) -> str:
    """Return a filesystem-safe filename."""
    name = name.strip().replace("\\", "_").replace("/", "_")
    name = re.sub(r"[^A-Za-z0-9._-]+", "_", name)
    name = re.sub(r"_+", "_", name).strip("._")
    return name or "image"


def infer_extension(url: str, content_type: str | None) -> str:
    """Infer a reasonable file extension from the URL or Content-Type."""
    parsed = urlparse(url)
    path = unquote(parsed.path)
    suffix = Path(path).suffix.lower()
    if suffix in {".png", ".jpg", ".jpeg", ".gif", ".webp", ".svg", ".bmp", ".tif", ".tiff"}:
        return suffix

    if content_type:
        guessed = mimetypes.guess_extension(content_type.split(";")[0].strip())
        if guessed:
            if guessed == ".jpe":
                return ".jpg"
            return guessed

    return ".img"


def build_local_filename(url: str, content_type: str | None, used_names: set[str]) -> str:
    """
    Build a collision-safe local filename from a URL.
    Adds a short hash suffix when needed.
    """
    parsed = urlparse(url)
    raw_name = Path(unquote(parsed.path)).name or "image"
    stem = sanitize_filename(Path(raw_name).stem or "image")
    ext = infer_extension(url, content_type)

    candidate = f"{stem}{ext}"
    if candidate not in used_names:
        used_names.add(candidate)
        return candidate

    short_hash = hashlib.sha1(url.encode("utf-8")).hexdigest()[:10]
    candidate = f"{stem}_{short_hash}{ext}"
    used_names.add(candidate)
    return candidate


def download_file(url: str, dst: Path, timeout: int = 30) -> str | None:
    """
    Download a URL to dst.
    Returns the response content-type if available.
    """
    with requests.get(url, stream=True, timeout=timeout) as resp:
        resp.raise_for_status()
        content_type = resp.headers.get("Content-Type")

        with dst.open("wb") as f:
            for chunk in resp.iter_content(chunk_size=8192):
                if chunk:
                    f.write(chunk)

    return content_type


def collect_remote_urls(text: str) -> list[str]:
    """Collect unique remote image URLs from HTML and Markdown image syntax."""
    urls: list[str] = []

    for match in HTML_IMG_RE.finditer(text):
        urls.append(match.group(2))

    for match in MD_IMG_RE.finditer(text):
        urls.append(match.group(2))

    # Preserve order while removing duplicates
    seen: set[str] = set()
    unique_urls: list[str] = []
    for url in urls:
        if url not in seen:
            seen.add(url)
            unique_urls.append(url)

    return unique_urls


def rewrite_markdown(text: str, url_to_local: Dict[str, str]) -> str:
    """Rewrite remote image URLs in HTML and Markdown image syntax to local paths."""

    def html_repl(match: re.Match[str]) -> str:
        prefix, url, suffix = match.groups()
        return f"{prefix}{url_to_local.get(url, url)}{suffix}"

    def md_repl(match: re.Match[str]) -> str:
        prefix, url, suffix = match.groups()
        return f"{prefix}{url_to_local.get(url, url)}{suffix}"

    text = HTML_IMG_RE.sub(html_repl, text)
    text = MD_IMG_RE.sub(md_repl, text)
    return text


def localize_markdown_images(
    md_path: Path,
    image_dir_name: str,
    output_path: Path | None,
    overwrite: bool,
) -> int:
    """
    Download remote images referenced by the markdown file and rewrite links.

    Returns:
        int: process exit code (0 for success, nonzero for partial/full failure).
    """
    if not md_path.exists():
        print(f"[ERROR] Markdown file not found: {md_path}", file=sys.stderr)
        return 2

    text = md_path.read_text(encoding="utf-8")

    urls = collect_remote_urls(text)
    if not urls:
        print("[INFO] No remote image URLs found.")
        if output_path and output_path != md_path:
            output_path.write_text(text, encoding="utf-8")
            print(f"[INFO] Wrote unchanged markdown to: {output_path}")
        return 0

    base_dir = md_path.parent
    image_dir = base_dir / image_dir_name
    image_dir.mkdir(parents=True, exist_ok=True)

    url_to_local: Dict[str, str] = {}
    used_names: set[str] = set(p.name for p in image_dir.iterdir() if p.is_file())

    failures: list[str] = []

    session = requests.Session()
    session.headers.update(
        {
            "User-Agent": "md-image-localizer/1.0",
        }
    )

    for idx, url in enumerate(urls, start=1):
        print(f"[{idx}/{len(urls)}] Downloading: {url}")

        try:
            # Probe headers first to infer better filename
            head_content_type: str | None = None
            try:
                head_resp = session.head(url, allow_redirects=True, timeout=20)
                if head_resp.ok:
                    head_content_type = head_resp.headers.get("Content-Type")
            except requests.RequestException:
                pass

            filename = build_local_filename(url, head_content_type, used_names)
            dst = image_dir / filename

            if not dst.exists():
                with session.get(url, stream=True, timeout=30) as resp:
                    resp.raise_for_status()
                    content_type = resp.headers.get("Content-Type") or head_content_type

                    # If extension was poor, rename before saving
                    better_ext = infer_extension(url, content_type)
                    if dst.suffix != better_ext:
                        better_name = build_local_filename(
                            f"{url}#resolved_ext={better_ext}",
                            content_type,
                            used_names,
                        )
                        dst = image_dir / better_name

                    with dst.open("wb") as f:
                        for chunk in resp.iter_content(chunk_size=8192):
                            if chunk:
                                f.write(chunk)

            local_ref = f"{image_dir_name}/{dst.name}"
            url_to_local[url] = local_ref

        except requests.RequestException as e:
            print(f"[WARN] Failed to download {url}: {e}", file=sys.stderr)
            failures.append(url)

    rewritten = rewrite_markdown(text, url_to_local)

    target = output_path if output_path is not None else md_path
    if target == md_path and not overwrite:
        print(
            "[ERROR] Refusing to overwrite the original markdown without --overwrite.",
            file=sys.stderr,
        )
        return 2

    target.write_text(rewritten, encoding="utf-8")

    print(f"[INFO] Wrote updated markdown to: {target}")
    print(f"[INFO] Downloaded {len(url_to_local)} / {len(urls)} images into: {image_dir}")

    if failures:
        print(f"[WARN] {len(failures)} image(s) failed to download.", file=sys.stderr)
        return 1

    return 0


def parse_args() -> argparse.Namespace:
    """Parse CLI arguments."""
    parser = argparse.ArgumentParser(
        description="Download remote images from a Markdown file and rewrite links to local paths."
    )
    parser.add_argument(
        "markdown",
        type=Path,
        help="Path to the input Markdown file.",
    )
    parser.add_argument(
        "--image-dir",
        default="images",
        help="Directory name (relative to the markdown file) to store downloaded images. Default: images",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=None,
        help="Optional output markdown path. If omitted, edits the input file in place.",
    )
    parser.add_argument(
        "--overwrite",
        action="store_true",
        help="Allow in-place overwrite of the input markdown file.",
    )
    return parser.parse_args()


def main() -> int:
    """CLI entry point."""
    args = parse_args()

    in_place = args.output is None
    if in_place and not args.overwrite:
        print(
            "[ERROR] In-place editing requested but --overwrite was not given.\n"
            "Use one of the following:\n"
            "  1) --output paper_local.md\n"
            "  2) --overwrite",
            file=sys.stderr,
        )
        return 2

    return localize_markdown_images(
        md_path=args.markdown,
        image_dir_name=args.image_dir,
        output_path=args.output,
        overwrite=args.overwrite,
    )


if __name__ == "__main__":
    raise SystemExit(main())
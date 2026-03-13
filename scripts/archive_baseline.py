#!/usr/bin/env python3
from __future__ import annotations

import argparse
import ast
import base64
import csv
import fnmatch
import hashlib
import json
import mimetypes
import os
import re
import shutil
import subprocess
import sys
import tarfile
from datetime import datetime
from pathlib import Path
from typing import Any, Iterable

sys.path.insert(
    0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "src"))
)

from revolution.backends import registered_backend_names  # noqa: E402

DEFAULT_ARCHIVE_ROOT = "baselines"
DEFAULT_EXCLUDES = [
    "__pycache__",
    ".pytest_cache",
    "*.pyc",
    "*.pyo",
    ".DS_Store",
]
RUN_STARTED_FORMAT = "%Y%m%d_%H%M%S"
IMAGE_LINK_RE = re.compile(r"!\[(?P<alt>[^\]]*)\]\((?P<target>[^)]+)\)")
CONFIG_SNAPSHOT_RE = re.compile(r".+_config\.(?:ya?ml|json)$", re.IGNORECASE)
MIME_OVERRIDES = {
    ".png": "image/png",
    ".jpg": "image/jpeg",
    ".jpeg": "image/jpeg",
    ".gif": "image/gif",
    ".svg": "image/svg+xml",
}
ARTIFACT_MODE_FULL = "full"
ARTIFACT_MODE_CANDIDATE_CORE = "candidate_core"
ARTIFACT_MODE_CHOICES = [ARTIFACT_MODE_FULL, ARTIFACT_MODE_CANDIDATE_CORE]
LEGACY_CANDIDATE_CODE_RE = re.compile(r"candidate_\d+(?:_[A-Za-z0-9.-]+)?\.(?:sv|v)$", re.IGNORECASE)
LEGACY_CANDIDATE_THOUGHT_RE = re.compile(
    r"candidate_\d+(?:_[A-Za-z0-9.-]+)?_thought\.txt$",
    re.IGNORECASE,
)
QD_SUMMARY_SIDECAR_NAMES = (
    "archive_history.jsonl",
    "archive_cells.csv",
    "archive_summary.json",
    "qd_metrics.json",
    "grid_layout.json",
    "centroids.json",
    "descriptor_health.json",
    "descriptor_health_report.md",
)
QD_VISUALIZATION_PATTERNS = (
    "coverage_vs_generation.png",
    "best_quality_vs_generation.png",
    "qd_score_vs_generation.png",
    "grid_*_heatmap.png",
    "cvt_*_projection.png",
)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Archive an experiment run into a compressed baseline package."
    )
    parser.add_argument(
        "--run-dir",
        required=True,
        help="Path to the experiment run directory to archive.",
    )
    parser.add_argument(
        "--backend",
        default=None,
        help="Backend label for the archive (overrides auto-detection).",
    )
    parser.add_argument(
        "--archive-root",
        default=DEFAULT_ARCHIVE_ROOT,
        help="Directory to store archives (default: baselines/).",
    )
    parser.add_argument(
        "--summary",
        nargs="*",
        default=None,
        help=(
            "Extra summary files to include. Defaults include *.md, "
            "*_summary_results.txt, and *_summary.json under run-dir."
        ),
    )
    parser.add_argument(
        "--exclude",
        nargs="*",
        default=None,
        help="Exclude patterns (fnmatch). Defaults include __pycache__ and .pytest_cache.",
    )
    parser.add_argument(
        "--plot-format",
        choices=["svg", "png"],
        default="png",
        help=(
            "Metadata-only field retained for compatibility with old archives. "
            "Summary plot regeneration is not performed in this repository."
        ),
    )
    parser.add_argument(
        "--no-regenerate-plots",
        action="store_true",
        help=(
            "Retained for compatibility. Plot regeneration is unsupported and "
            "this flag has no effect."
        ),
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="Overwrite an existing archive directory if it already exists.",
    )
    parser.add_argument(
        "--no-embed-images",
        action="store_true",
        help="Skip embedding images into summary markdown.",
    )
    parser.add_argument(
        "--plot-assets-dir",
        default=None,
        help=(
            "Archive-relative directory to store copied plot/image assets and rewrite "
            "markdown image links (implies --no-embed-images). Example: plots"
        ),
    )
    parser.add_argument(
        "--artifact-mode",
        choices=ARTIFACT_MODE_CHOICES,
        default=ARTIFACT_MODE_CANDIDATE_CORE,
        help=(
            "Artifact packing mode. 'candidate_core' (default) keeps only candidate "
            "code/thought/feedback files in artifacts/raw_results.tar.xz. Use 'full' "
            "to keep all non-summary raw outputs."
        ),
    )
    return parser.parse_args()


def _repo_root() -> Path:
    return Path(__file__).resolve().parents[1]


def _resolve_path(path: str | Path, base: Path) -> Path:
    target = Path(path).expanduser()
    if not target.is_absolute():
        target = (base / target).resolve()
    return target


def _load_json(path: Path) -> dict[str, Any]:
    try:
        with path.open("r", encoding="utf-8") as handle:
            payload = json.load(handle)
    except FileNotFoundError:
        return {}
    except json.JSONDecodeError:
        return {}
    if not isinstance(payload, dict):
        return {}
    return payload


def _find_run_logs(run_dir: Path) -> list[Path]:
    return sorted(path for path in run_dir.rglob("*_run_log.txt") if path.is_file())


def _select_primary_run_log(run_logs: list[Path]) -> Path | None:
    if not run_logs:
        return None
    return run_logs[0]


def _detect_archive_type(run_dir: Path) -> str:
    has_backend_root = any(
        (run_dir / name).is_dir() for name in registered_backend_names()
    )
    has_comparison_report = (run_dir / "backend_comparison.md").is_file()
    if has_backend_root or has_comparison_report:
        return "ablation_run"

    has_problem_summaries = any(run_dir.rglob("*_summary.json"))
    has_master_logs = any(run_dir.rglob("*_run_log.txt"))
    if has_problem_summaries and has_master_logs:
        return "single_run"
    return "generic_exp_root"


def _parse_run_arguments(run_log: Path | None) -> dict[str, Any]:
    if run_log is None:
        return {}
    try:
        with run_log.open("r", encoding="utf-8") as handle:
            for line in handle:
                if not line.startswith("Arguments:"):
                    continue
                raw = line.split("Arguments:", 1)[1].strip()
                try:
                    parsed = ast.literal_eval(raw)
                except (ValueError, SyntaxError):
                    return {}
                if isinstance(parsed, dict):
                    return parsed
                return {}
    except FileNotFoundError:
        return {}
    return {}


def _parse_default_llm_settings(run_log: Path | None) -> dict[str, Any]:
    if run_log is None:
        return {}
    settings: dict[str, Any] = {}
    try:
        with run_log.open("r", encoding="utf-8") as handle:
            for raw_line in handle:
                line = raw_line.strip()
                if not line.startswith("default_llm_"):
                    continue
                key, _, value = line.partition(":")
                if not key or not value:
                    continue
                settings[key.strip()] = _coerce_scalar(value.strip())
    except FileNotFoundError:
        return {}
    return settings


def _parse_run_started(
    run_metadata: dict[str, Any], run_log: Path | None
) -> tuple[str | None, str | None]:
    run_started = run_metadata.get("run_started")
    if isinstance(run_started, str) and run_started:
        return run_started, _format_run_started_iso(run_started)

    if run_log is None or not run_log.exists():
        return None, None

    pattern = re.compile(r"Run Started:\s*(\d{8}_\d{6})")
    with run_log.open("r", encoding="utf-8") as handle:
        for line in handle:
            match = pattern.search(line)
            if match:
                value = match.group(1)
                return value, _format_run_started_iso(value)
    return None, None


def _format_run_started_iso(run_started: str) -> str | None:
    try:
        dt = datetime.strptime(run_started, RUN_STARTED_FORMAT)
    except ValueError:
        return None
    return dt.isoformat(timespec="seconds")


def _parse_git_commit_from_log(run_log: Path | None) -> str | None:
    if run_log is None:
        return None
    try:
        with run_log.open("r", encoding="utf-8") as handle:
            for line in handle:
                if line.startswith("Git commit"):
                    value = line.split(":", 1)[1].strip()
                    return value or None
    except FileNotFoundError:
        return None
    return None


def _get_git_head(repo_root: Path) -> str | None:
    result = subprocess.run(
        ["git", "-C", str(repo_root), "rev-parse", "HEAD"],
        capture_output=True,
        text=True,
        check=False,
    )
    if result.returncode != 0:
        return None
    return result.stdout.strip() or None


def _get_git_commit_time(repo_root: Path, commit_hash: str | None) -> str | None:
    if not commit_hash:
        return None
    result = subprocess.run(
        ["git", "-C", str(repo_root), "show", "-s", "--format=%cI", commit_hash],
        capture_output=True,
        text=True,
        check=False,
    )
    if result.returncode != 0:
        return None
    return result.stdout.strip() or None


def _coerce_scalar(value: str) -> Any:
    for caster in (int, float):
        try:
            return caster(value)
        except ValueError:
            continue
    lower = value.lower()
    if lower in {"true", "false"}:
        return lower == "true"
    return value


def _determine_backend(backend_arg: str | None, args: dict[str, Any]) -> str | None:
    if backend_arg:
        return backend_arg
    for key in ("backend", "iccad_backend"):
        value = args.get(key)
        if isinstance(value, str) and value:
            return value
    return None


def _dedupe_paths(paths: Iterable[Path]) -> list[Path]:
    seen: set[Path] = set()
    deduped: list[Path] = []
    for path in paths:
        try:
            resolved = path.resolve()
        except FileNotFoundError:
            resolved = path
        if resolved in seen:
            continue
        seen.add(resolved)
        deduped.append(resolved)
    return deduped


def _collect_summary_files(run_dir: Path, extra_summary: Iterable[str] | None) -> list[Path]:
    """Collect user-facing run summaries plus QD archive sidecars."""

    summary_candidates = [
        *run_dir.rglob("*.md"),
        *run_dir.rglob("*_summary_results.txt"),
        *run_dir.rglob("*_summary.json"),
        *(
            path
            for name in QD_SUMMARY_SIDECAR_NAMES
            for path in run_dir.rglob(name)
        ),
        *(
            path
            for pattern in QD_VISUALIZATION_PATTERNS
            for path in run_dir.rglob(pattern)
        ),
    ]

    extras: list[Path] = []
    if extra_summary:
        for raw in extra_summary:
            if any(ch in raw for ch in "*?[]"):
                extras.extend(run_dir.glob(raw))
                continue
            path = Path(raw)
            if not path.is_absolute():
                path = run_dir / path
            extras.append(path)

    existing = [path for path in summary_candidates + extras if path.exists() and path.is_file()]
    return _dedupe_paths(existing)


def _collect_config_snapshots(run_dir: Path) -> list[Path]:
    config_paths = [
        path
        for path in run_dir.rglob("*")
        if path.is_file() and CONFIG_SNAPSHOT_RE.fullmatch(path.name)
    ]
    return sorted(_dedupe_paths(config_paths))


def _summary_destination(summary_path: Path, run_dir: Path, summaries_dir: Path) -> Path:
    try:
        rel = summary_path.relative_to(run_dir)
        return summaries_dir / rel
    except ValueError:
        return summaries_dir / summary_path.name


def _config_destination(config_path: Path, run_dir: Path, configs_dir: Path) -> Path:
    try:
        rel = config_path.relative_to(run_dir)
        return configs_dir / rel
    except ValueError:
        digest = hashlib.sha1(str(config_path).encode("utf-8")).hexdigest()[:12]
        return configs_dir / "_external" / f"{digest}_{config_path.name}"


def _parse_image_target(target: str) -> tuple[str, str]:
    target = target.strip()
    if target.startswith("<") and target.endswith(">"):
        target = target[1:-1]
    match = re.match(r'(?P<url>\S+)(?P<title>\s+".*")?$', target)
    if not match:
        return target, ""
    return match.group("url"), match.group("title") or ""


def _normalize_archive_relative_dir(path: str, *, option_name: str) -> Path:
    raw = path.strip()
    if not raw:
        raise ValueError(f"{option_name} must not be empty.")
    candidate = Path(raw)
    if candidate.is_absolute():
        raise ValueError(f"{option_name} must be archive-relative, got absolute path: {path}")
    normalized = Path(os.path.normpath(candidate.as_posix()))
    if normalized == Path("."):
        raise ValueError(f"{option_name} must not resolve to the archive root.")
    if ".." in normalized.parts:
        raise ValueError(f"{option_name} must not escape the archive directory: {path}")
    return normalized


def _embed_images(markdown: str, base_dir: Path) -> tuple[str, dict[str, Any]]:
    embedded = 0
    missing: list[str] = []

    def _replace(match: re.Match) -> str:
        nonlocal embedded
        target = match.group("target")
        url, title = _parse_image_target(target)
        if url.startswith(("http://", "https://", "data:")):
            return match.group(0)
        image_path = Path(url)
        if not image_path.is_absolute():
            image_path = (base_dir / image_path).resolve()
        if not image_path.exists() or not image_path.is_file():
            missing.append(str(image_path))
            return match.group(0)
        mime = MIME_OVERRIDES.get(image_path.suffix.lower())
        if mime is None:
            mime = mimetypes.guess_type(image_path)[0] or "application/octet-stream"
        with image_path.open("rb") as handle:
            payload = base64.b64encode(handle.read()).decode("ascii")
        embedded += 1
        return f"![{match.group('alt')}](data:{mime};base64,{payload}{title})"

    updated = IMAGE_LINK_RE.sub(_replace, markdown)
    return updated, {"embedded": embedded, "missing": missing}


def _copy_plot_asset(source: Path, run_dir: Path, plot_assets_root: Path) -> Path:
    source = source.resolve()
    try:
        relative_to_run = source.relative_to(run_dir)
        return plot_assets_root / relative_to_run
    except ValueError:
        digest = hashlib.sha1(str(source).encode("utf-8")).hexdigest()[:12]
        safe_name = re.sub(r"[^A-Za-z0-9._-]+", "_", source.name) or "asset"
        return plot_assets_root / "_external" / f"{digest}_{safe_name}"


def _rewrite_images_to_plot_assets(
    markdown: str,
    base_dir: Path,
    summary_dest: Path,
    run_dir: Path,
    plot_assets_root: Path,
) -> tuple[str, dict[str, Any]]:
    rewritten = 0
    missing: list[str] = []
    copied: set[Path] = set()

    def _replace(match: re.Match) -> str:
        nonlocal rewritten
        target = match.group("target")
        url, title = _parse_image_target(target)
        if url.startswith(("http://", "https://", "data:")):
            return match.group(0)
        image_path = Path(url)
        if not image_path.is_absolute():
            image_path = (base_dir / image_path).resolve()
        if not image_path.exists() or not image_path.is_file():
            missing.append(str(image_path))
            return match.group(0)
        copied_path = _copy_plot_asset(image_path, run_dir, plot_assets_root)
        if copied_path not in copied:
            copied_path.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(image_path, copied_path)
            copied.add(copied_path)
        rewritten += 1
        rewritten_target = Path(
            os.path.relpath(copied_path, summary_dest.parent)
        ).as_posix()
        return f"![{match.group('alt')}]({rewritten_target}{title})"

    updated = IMAGE_LINK_RE.sub(_replace, markdown)
    copied_sorted = sorted(copied)
    return updated, {
        "rewritten": rewritten,
        "copied": len(copied_sorted),
        "missing": missing,
        "copied_files": [str(path) for path in copied_sorted],
    }


def _write_summaries(
    summary_paths: Iterable[Path],
    run_dir: Path,
    summaries_dir: Path,
    embed_images: bool,
    plot_assets_root: Path | None = None,
) -> list[dict[str, Any]]:
    summaries_dir.mkdir(parents=True, exist_ok=True)
    summary_info: list[dict[str, Any]] = []

    for path in summary_paths:
        if not path.exists() or not path.is_file():
            continue
        dest = _summary_destination(path, run_dir, summaries_dir)
        dest.parent.mkdir(parents=True, exist_ok=True)
        content = path.read_text(encoding="utf-8")
        embed_info: dict[str, Any] = {"embedded": 0, "missing": []}
        plot_info: dict[str, Any] = {"rewritten": 0, "copied": 0, "missing": [], "copied_files": []}
        if embed_images and path.suffix.lower() == ".md":
            content, embed_info = _embed_images(content, path.parent)
        elif plot_assets_root is not None and path.suffix.lower() == ".md":
            content, plot_info = _rewrite_images_to_plot_assets(
                content,
                path.parent,
                dest,
                run_dir,
                plot_assets_root,
            )
        dest.write_text(content, encoding="utf-8")
        missing_images = [str(item) for item in embed_info.get("missing", [])] + [
            str(item) for item in plot_info.get("missing", [])
        ]
        summary_info.append(
            {
                "source": str(path),
                "archived": str(dest),
                "embedded_images": embed_info["embedded"],
                "rewritten_image_links": plot_info["rewritten"],
                "copied_images": plot_info["copied"],
                "copied_plot_files": plot_info["copied_files"],
                "missing_images": missing_images,
            }
        )
    return summary_info


def _write_config_snapshots(
    config_paths: Iterable[Path],
    run_dir: Path,
    configs_dir: Path,
) -> list[dict[str, Any]]:
    configs_dir.mkdir(parents=True, exist_ok=True)
    entries: list[dict[str, Any]] = []
    for path in config_paths:
        if not path.exists() or not path.is_file():
            continue
        dest = _config_destination(path, run_dir, configs_dir)
        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(path, dest)
        entries.append({"source": str(path), "archived": str(dest)})
    return entries


def _is_excluded(rel_path: Path, patterns: Iterable[str]) -> bool:
    rel_str = rel_path.as_posix()
    for pattern in patterns:
        if fnmatch.fnmatch(rel_str, pattern):
            return True
        for part in rel_path.parts:
            if fnmatch.fnmatch(part, pattern):
                return True
    return False


def _under_any_root(path: Path, roots: Iterable[Path]) -> bool:
    resolved = path.resolve()
    for root in roots:
        try:
            resolved.relative_to(root.resolve())
            return True
        except ValueError:
            continue
    return False


def _collect_artifacts(
    run_dir: Path,
    excluded_files: set[Path],
    patterns: Iterable[str],
    skip_roots: Iterable[Path] | None = None,
) -> list[Path]:
    artifacts: list[Path] = []
    skip_roots = list(skip_roots or [])

    for root, dirs, files in os.walk(run_dir):
        root_path = Path(root)
        rel_root = root_path.relative_to(run_dir)

        kept_dirs: list[str] = []
        for name in dirs:
            candidate = root_path / name
            if _is_excluded(rel_root / name, patterns):
                continue
            if _under_any_root(candidate, skip_roots):
                continue
            kept_dirs.append(name)
        dirs[:] = kept_dirs

        for name in files:
            path = root_path / name
            rel_path = path.relative_to(run_dir)
            if _is_excluded(rel_path, patterns):
                continue
            if _under_any_root(path, skip_roots):
                continue
            try:
                resolved = path.resolve()
            except FileNotFoundError:
                continue
            if resolved in excluded_files:
                continue
            artifacts.append(path)
    return artifacts


def _write_artifacts_tar(artifacts: Iterable[Path], run_dir: Path, destination: Path) -> None:
    destination.parent.mkdir(parents=True, exist_ok=True)
    with tarfile.open(destination, "w:xz") as tar:
        for path in artifacts:
            rel = path.relative_to(run_dir)
            tar.add(path, arcname=rel)


def _is_candidate_core_artifact(path: Path) -> bool:
    filename = path.name.lower()
    if filename in {"code.sv", "code.v", "thought.txt"}:
        return True
    if filename.endswith("_feedback.txt"):
        return True
    if LEGACY_CANDIDATE_CODE_RE.fullmatch(filename):
        return True
    if LEGACY_CANDIDATE_THOUGHT_RE.fullmatch(filename):
        return True
    return False


def _filter_artifacts_by_mode(artifacts: Iterable[Path], artifact_mode: str) -> list[Path]:
    if artifact_mode == ARTIFACT_MODE_FULL:
        return list(artifacts)
    if artifact_mode == ARTIFACT_MODE_CANDIDATE_CORE:
        return [path for path in artifacts if _is_candidate_core_artifact(path)]
    raise ValueError(f"Unsupported artifact_mode: {artifact_mode}")


def _sanitize_tag(tag: str | None) -> str:
    if not tag:
        return "unknown"
    safe = re.sub(r"[^A-Za-z0-9._-]+", "_", tag)
    return safe.strip("_") or "unknown"


def _build_command_settings(args: dict[str, Any], defaults: dict[str, Any]) -> dict[str, Any]:
    keys = [
        "api_backend",
        "model_name",
        "model",
        "max_tokens",
        "num_generations",
        "population_size",
        "num_samples",
        "num_workers",
        "candidate_workers",
        "prompt_profile",
        "backend",
    ]
    settings = {key: args[key] for key in keys if key in args}
    settings.update(defaults)
    if "model_length" not in settings:
        if "max_tokens" in settings:
            settings["model_length"] = settings["max_tokens"]
        elif "default_llm_max_tokens" in settings:
            settings["model_length"] = settings["default_llm_max_tokens"]
    return settings


def _write_manifest(manifest_path: Path, manifest: dict[str, Any]) -> None:
    manifest_path.write_text(json.dumps(manifest, indent=2), encoding="utf-8")


def _write_readme(readme_path: Path, manifest: dict[str, Any]) -> None:
    lines = [
        "# Baseline Archive",
        "",
        f"- Archive time: {manifest.get('archive_time')}",
        f"- Archive type: {manifest.get('archive_type')}",
        f"- Run started: {manifest.get('run_started_iso') or manifest.get('run_started')}",
        f"- Git commit: {manifest.get('git_commit')}",
        f"- Commit time: {manifest.get('git_commit_time')}",
        f"- Backend: {manifest.get('backend')}",
        f"- Plot format: {manifest.get('plot_format')}",
        f"- Image mode: {manifest.get('image_mode')}",
        f"- Artifact mode: {manifest.get('artifact_mode')}",
        f"- Artifact file count: {manifest.get('artifact_file_count')}",
        f"- Config snapshots: {manifest.get('config_snapshot_count', 0)}",
        f"- Model: {manifest.get('command_settings', {}).get('model_name')}",
        f"- Generations: {manifest.get('command_settings', {}).get('num_generations')}",
        f"- Population size: {manifest.get('command_settings', {}).get('population_size')}",
        f"- Max tokens: {manifest.get('command_settings', {}).get('max_tokens')}",
    ]
    plot_assets_dir = manifest.get("plot_assets_dir")
    if plot_assets_dir:
        lines.append(f"- Plot assets dir: {plot_assets_dir}")
    lines.extend(["", "Summary files:"])
    summary_info = manifest.get("summary_files", [])
    if summary_info:
        for entry in summary_info:
            lines.append(f"- {entry.get('archived')}")
    else:
        lines.append("- None")

    lines.extend(["", "Config snapshots:"])
    config_info = manifest.get("config_snapshots", [])
    for entry in config_info:
        lines.append(f"- {entry.get('archived')}")
    if not config_info:
        lines.append("- None")

    lines.extend(["", "Artifacts:", f"- {manifest.get('artifacts_tar')}"])
    readme_path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def _merge_index_fields(existing: list[str], new: list[str]) -> list[str]:
    merged = list(existing)
    for field in new:
        if field not in merged:
            merged.append(field)
    return merged


def _rewrite_index_csv(index_path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    with index_path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        for row in rows:
            writer.writerow({key: row.get(key, "") for key in fieldnames})


def _append_index_csv(index_path: Path, row: dict[str, Any], fieldnames: list[str]) -> None:
    index_path.parent.mkdir(parents=True, exist_ok=True)
    if index_path.exists() and index_path.stat().st_size > 0:
        with index_path.open("r", newline="", encoding="utf-8") as handle:
            reader = csv.DictReader(handle)
            existing_fields = list(reader.fieldnames or [])
            rows = list(reader)
        merged_fields = _merge_index_fields(existing_fields, fieldnames)
        if merged_fields != existing_fields:
            _rewrite_index_csv(index_path, rows, merged_fields)
            fieldnames = merged_fields
        with index_path.open("a", newline="", encoding="utf-8") as handle:
            writer = csv.DictWriter(handle, fieldnames=fieldnames)
            writer.writerow({key: row.get(key, "") for key in fieldnames})
        return

    with index_path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerow({key: row.get(key, "") for key in fieldnames})


def _append_index_jsonl(index_path: Path, payload: dict[str, Any]) -> None:
    index_path.parent.mkdir(parents=True, exist_ok=True)
    with index_path.open("a", encoding="utf-8") as handle:
        handle.write(json.dumps(payload) + "\n")


def archive_baseline(
    run_dir: Path,
    archive_root: Path,
    backend: str | None = None,
    summary_files: Iterable[str] | None = None,
    exclude: Iterable[str] | None = None,
    force: bool = False,
    embed_images: bool = True,
    plot_assets_dir: str | None = None,
    plot_format: str = "png",
    regenerate_plots: bool = True,
    artifact_mode: str = ARTIFACT_MODE_CANDIDATE_CORE,
) -> Path:
    run_dir = run_dir.resolve()
    archive_root = archive_root.resolve()
    if not run_dir.exists() or not run_dir.is_dir():
        raise FileNotFoundError(f"Run directory does not exist: {run_dir}")
    if embed_images and plot_assets_dir:
        raise ValueError(
            "plot_assets_dir cannot be used with embedded images; disable embedding first."
        )
    if artifact_mode not in ARTIFACT_MODE_CHOICES:
        raise ValueError(
            f"Unsupported artifact_mode: {artifact_mode}. "
            f"Expected one of: {', '.join(ARTIFACT_MODE_CHOICES)}."
        )
    plot_assets_rel: Path | None = None
    if plot_assets_dir:
        plot_assets_rel = _normalize_archive_relative_dir(
            plot_assets_dir, option_name="plot_assets_dir"
        )

    if regenerate_plots:
        print(
            "Info: summary plot regeneration is not supported in this repository. "
            "Archiving existing outputs."
        )

    run_logs = _find_run_logs(run_dir)
    run_log = _select_primary_run_log(run_logs)
    run_metadata = _load_json(run_dir / "run_metadata.json")
    archive_type = _detect_archive_type(run_dir)

    args = _parse_run_arguments(run_log)
    defaults = _parse_default_llm_settings(run_log)
    run_started, run_started_iso = _parse_run_started(run_metadata, run_log)

    repo_root = _repo_root()
    git_commit = (
        run_metadata.get("git_commit")
        or args.get("git_commit")
        or _parse_git_commit_from_log(run_log)
        or _get_git_head(repo_root)
    )
    git_commit_time = _get_git_commit_time(repo_root, git_commit)

    backend_value = _determine_backend(backend, args)
    run_tag = run_started or datetime.now().strftime(RUN_STARTED_FORMAT)
    archive_dir = (
        archive_root
        / f"{run_tag}__{_sanitize_tag(git_commit)[:8]}__{_sanitize_tag(backend_value)}"
    )
    if archive_dir.exists():
        if not force:
            raise FileExistsError(f"Archive already exists: {archive_dir}")
        shutil.rmtree(archive_dir)
    archive_dir.mkdir(parents=True, exist_ok=True)

    config_paths = _collect_config_snapshots(run_dir)
    if not config_paths:
        raise ValueError(
            "No run configuration snapshots found under run-dir. "
            "Expected files matching '*_config.yaml', '*_config.yml', or '*_config.json'."
        )

    summary_paths = _collect_summary_files(run_dir, summary_files)
    summaries_dir = archive_dir / "summaries"
    plot_assets_root = archive_dir / plot_assets_rel if plot_assets_rel else None
    summary_info = _write_summaries(
        summary_paths,
        run_dir,
        summaries_dir,
        embed_images,
        plot_assets_root=plot_assets_root,
    )

    config_info = _write_config_snapshots(config_paths, run_dir, archive_dir / "configs")

    exclude_patterns = list(DEFAULT_EXCLUDES)
    if exclude:
        exclude_patterns.extend(exclude)

    summary_path_set = {Path(entry["source"]).resolve() for entry in summary_info}
    skip_roots: list[Path] = []
    try:
        archive_dir.relative_to(run_dir)
        skip_roots.append(archive_dir)
    except ValueError:
        pass
    artifacts = _collect_artifacts(
        run_dir,
        summary_path_set,
        exclude_patterns,
        skip_roots=skip_roots,
    )
    artifacts = _filter_artifacts_by_mode(artifacts, artifact_mode)
    artifacts_tar = archive_dir / "artifacts" / "raw_results.tar.xz"
    _write_artifacts_tar(artifacts, run_dir, artifacts_tar)

    command_settings = _build_command_settings(args, defaults)
    image_mode = "embedded" if embed_images else ("copied" if plot_assets_rel else "linked")

    manifest = {
        "archive_version": 3,
        "archive_time": datetime.now().isoformat(timespec="seconds"),
        "archive_dir": str(archive_dir),
        "archive_root": str(archive_root),
        "archive_type": archive_type,
        "run_dir": str(run_dir),
        "plot_format": plot_format,
        "plot_regenerated": False,
        "embed_images": embed_images,
        "plot_assets_dir": str(plot_assets_rel) if plot_assets_rel else None,
        "image_mode": image_mode,
        "run_started": run_started,
        "run_started_iso": run_started_iso,
        "git_commit": git_commit,
        "git_commit_time": git_commit_time,
        "backend": backend_value,
        "command_args": args,
        "command_settings": command_settings,
        "run_logs": [str(path) for path in run_logs],
        "summary_files": summary_info,
        "config_snapshots": config_info,
        "config_snapshot_count": len(config_info),
        "artifact_mode": artifact_mode,
        "artifact_file_count": len(artifacts),
        "artifacts_tar": str(artifacts_tar),
        "excluded_patterns": exclude_patterns,
    }

    _write_manifest(archive_dir / "manifest.json", manifest)
    _write_readme(archive_dir / "README.md", manifest)

    index_row = {
        "archive_time": manifest["archive_time"],
        "run_started": run_started_iso or run_started or "",
        "git_commit": git_commit or "",
        "git_commit_time": git_commit_time or "",
        "backend": backend_value or "",
        "model_name": command_settings.get("model_name") or command_settings.get("model") or "",
        "num_generations": command_settings.get("num_generations") or "",
        "population_size": command_settings.get("population_size") or "",
        "max_tokens": command_settings.get("max_tokens") or "",
        "archive_type": archive_type,
        "config_snapshot_count": len(config_info),
        "artifact_mode": artifact_mode,
        "artifact_file_count": len(artifacts),
        "archive_dir": str(archive_dir),
        "run_dir": str(run_dir),
        "plot_format": plot_format,
        "image_mode": image_mode,
        "plot_assets_dir": str(plot_assets_rel) if plot_assets_rel else "",
    }
    index_fields = list(index_row.keys())
    _append_index_csv(archive_root / "index.csv", index_row, index_fields)
    _append_index_jsonl(archive_root / "index.jsonl", manifest)

    return archive_dir


def main() -> None:
    args = parse_args()
    repo_root = _repo_root()
    run_dir = _resolve_path(args.run_dir, repo_root)
    archive_root = _resolve_path(args.archive_root, repo_root)
    embed_images = not args.no_embed_images and not args.plot_assets_dir
    archive_dir = archive_baseline(
        run_dir=run_dir,
        archive_root=archive_root,
        backend=args.backend,
        summary_files=args.summary,
        exclude=args.exclude,
        force=args.force,
        embed_images=embed_images,
        plot_assets_dir=args.plot_assets_dir,
        plot_format=args.plot_format,
        regenerate_plots=not args.no_regenerate_plots,
        artifact_mode=args.artifact_mode,
    )
    print(f"Archive created at: {archive_dir}")


if __name__ == "__main__":
    main()

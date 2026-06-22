#!/usr/bin/env python3
"""Generate T33 Qwen3 preprocessing views and committed manifests."""

from __future__ import annotations

import argparse
import csv
import hashlib
import re
from pathlib import Path

IDENT_RE = re.compile(r"\b[A-Za-z_][A-Za-z0-9_$]*\b")
PORT_DECL_RE = re.compile(
    r"\b(input|output|inout)\b\s*(?:wire|reg|logic)?\s*(?:signed\s*)?"
    r"(?:\[[^\]]+\]\s*)?([A-Za-z_][A-Za-z0-9_$]*)"
)
NET_DECL_RE = re.compile(
    r"\b(wire|reg|logic)\b\s*(?:signed\s*)?(?:\[[^\]]+\]\s*)?([^;]+);",
    re.DOTALL,
)
ATTR_RE = re.compile(r"\(\*.*?\*\)", re.DOTALL)
BLOCK_COMMENT_RE = re.compile(r"/\*.*?\*/", re.DOTALL)
LINE_COMMENT_RE = re.compile(r"//.*")

VERILOG_WORDS = {
    "always",
    "assign",
    "begin",
    "case",
    "default",
    "else",
    "end",
    "endcase",
    "endmodule",
    "for",
    "function",
    "generate",
    "genvar",
    "if",
    "inout",
    "input",
    "integer",
    "localparam",
    "logic",
    "module",
    "negedge",
    "or",
    "output",
    "parameter",
    "posedge",
    "reg",
    "signed",
    "wire",
}

YOSYS_WORDS = {
    "add",
    "adff",
    "and",
    "concat",
    "dff",
    "div",
    "eq",
    "ge",
    "gt",
    "le",
    "logic_not",
    "lt",
    "memrd",
    "memwr",
    "mod",
    "mul",
    "mux",
    "ne",
    "not",
    "or",
    "pmux",
    "reduce_and",
    "reduce_or",
    "reduce_xor",
    "sdff",
    "shl",
    "shr",
    "slice",
    "sshl",
    "sshr",
    "sub",
    "xor",
}

STRUCTURAL_COLUMNS = (
    "rtl_line_count",
    "rtl_assign_count",
    "rtl_always_count",
    "rtl_case_count",
    "rtl_if_count",
    "rtl_ternary_count",
    "rtl_nonblocking_count",
    "rtl_blocking_count",
    "rtl_add_count",
    "rtl_mul_count",
    "rtl_wire_count",
    "rtl_reg_count",
)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--candidates-csv", required=True, type=Path)
    parser.add_argument("--output-root", required=True, type=Path)
    parser.add_argument("--package-dir", required=True, type=Path)
    args = parser.parse_args(argv)

    rows = read_rows(args.candidates_csv)
    manifest = write_views(rows, args.output_root)
    table_dir = args.package_dir / "tables"
    table_dir.mkdir(parents=True, exist_ok=True)
    write_csv(table_dir / "t33_preprocessing_view_manifest.csv", manifest)
    write_csv(table_dir / "t33_preprocessing_view_summary.csv", summary_rows(manifest))
    write_csv(
        table_dir / "t33_preprocessing_cache_manifest.csv",
        cache_rows(args.candidates_csv, args.output_root, rows, manifest),
    )
    print(f"Generated {len(manifest)} T33 view files under {args.output_root}")
    return 0


def read_rows(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8", newline="") as handle:
        rows = list(csv.DictReader(handle))
    assert rows
    return rows


def write_views(rows: list[dict[str, str]], output_root: Path) -> list[dict[str, object]]:
    manifest = []
    for row in rows:
        for view, text, source_path in build_views(row):
            path = view_path(output_root, view, row)
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(text, encoding="utf-8")
            manifest.append(manifest_row(row, view, source_path, path, text))
    return manifest


def build_views(row: dict[str, str]) -> list[tuple[str, str, Path]]:
    rtl_path = Path(row["rtl_path"])
    netlist_path = Path(row["netlist_path"])
    assert rtl_path.is_file(), rtl_path
    assert netlist_path.is_file(), netlist_path
    raw_rtl = rtl_path.read_text(encoding="utf-8", errors="ignore")
    raw_netlist = netlist_path.read_text(encoding="utf-8", errors="ignore")
    commentless = strip_comments(raw_rtl)
    identifier_role = role_normalize(commentless)
    canonical_rtl = canonical_text(identifier_role)
    canonical_netlist = canonical_text(role_normalize(strip_attributes(raw_netlist)))
    summary = structural_summary(row, canonical_netlist)
    return [
        ("raw_rtl", ensure_newline(raw_rtl), rtl_path),
        ("commentless_rtl", ensure_newline(commentless), rtl_path),
        ("identifier_role_rtl", ensure_newline(identifier_role), rtl_path),
        ("canonical_rtl", canonical_rtl, rtl_path),
        ("canonical_yosys_netlist", canonical_netlist, netlist_path),
        ("summary_plus_netlist", ensure_newline(summary + "\n" + canonical_netlist), netlist_path),
    ]


def strip_comments(text: str) -> str:
    return LINE_COMMENT_RE.sub("", BLOCK_COMMENT_RE.sub("", text))


def strip_attributes(text: str) -> str:
    return strip_comments(ATTR_RE.sub("", text))


def role_normalize(text: str) -> str:
    mapping = declared_roles(text)
    counters: dict[str, int] = {}

    def replace(match: re.Match[str]) -> str:
        token = match.group(0)
        if match.start() > 0 and text[match.start() - 1] == "'":
            return token
        if token in VERILOG_WORDS or token in YOSYS_WORDS:
            return token
        if token not in mapping:
            mapping[token] = next_name(counters, "tmp")
        return mapping[token]

    return IDENT_RE.sub(replace, text)


def declared_roles(text: str) -> dict[str, str]:
    mapping: dict[str, str] = {}
    counters: dict[str, int] = {}
    for role, token in PORT_DECL_RE.findall(text):
        if token not in VERILOG_WORDS and token not in YOSYS_WORDS and token not in mapping:
            mapping[token] = next_name(counters, role)
    for role, body in NET_DECL_RE.findall(text):
        prefix = role_prefix(role)
        for token in IDENT_RE.findall(body):
            if token in VERILOG_WORDS or token in YOSYS_WORDS or token in mapping:
                continue
            mapping[token] = next_name(counters, prefix)
    return mapping


def role_prefix(role: str) -> str:
    if role in {"input", "output", "inout"}:
        return role
    if role == "reg":
        return "reg"
    return "wire"


def next_name(counters: dict[str, int], prefix: str) -> str:
    index = counters.get(prefix, 0)
    counters[prefix] = index + 1
    return f"{prefix}_{index:04d}"


def canonical_text(text: str) -> str:
    statements = []
    for part in text.split(";"):
        statement = " ".join(part.split())
        if statement:
            statements.append(statement + ";")
    return "\n".join(statements) + "\n"


def structural_summary(row: dict[str, str], canonical_netlist: str) -> str:
    lines = ["structural_summary_v0"]
    for column in STRUCTURAL_COLUMNS:
        lines.append(f"{column}: {row[column]}")
    lines.append(f"style_cluster: {row['style_cluster']}")
    lines.append(f"netlist_line_count: {line_count(canonical_netlist)}")
    lines.append(f"netlist_char_count: {len(canonical_netlist)}")
    return "\n".join(lines) + "\n"


def view_path(output_root: Path, view: str, row: dict[str, str]) -> Path:
    sample = int(row["sample_index"])
    return output_root / "views" / view / f"{sample:04d}_{row['candidate_id']}.txt"


def manifest_row(
    row: dict[str, str],
    view: str,
    source_path: Path,
    output_path: Path,
    text: str,
) -> dict[str, object]:
    return {
        "sample_index": row["sample_index"],
        "candidate_id": row["candidate_id"],
        "view": view,
        "source_path": source_path.as_posix(),
        "output_path": output_path.as_posix(),
        "char_count": len(text),
        "line_count": line_count(text),
        "sha256": sha256_text(text),
    }


def summary_rows(manifest: list[dict[str, object]]) -> list[dict[str, object]]:
    views = sorted({str(row["view"]) for row in manifest})
    rows: list[dict[str, object]] = []
    for view in views:
        view_rows = [row for row in manifest if row["view"] == view]
        chars = [char_count(row) for row in view_rows]
        rows.append(
            {
                "view": view,
                "candidate_count": len(view_rows),
                "total_chars": sum(chars),
                "mean_chars": f"{sum(chars) / len(chars):.2f}",
                "min_chars": min(chars),
                "max_chars": max(chars),
            }
        )
    return rows


def char_count(row: dict[str, object]) -> int:
    value = row["char_count"]
    assert isinstance(value, int)
    return value


def cache_rows(
    candidates_csv: Path,
    output_root: Path,
    rows: list[dict[str, str]],
    manifest: list[dict[str, object]],
) -> list[dict[str, object]]:
    return [
        {
            "source_candidates_csv": candidates_csv.as_posix(),
            "source_candidates_sha256": sha256_file(candidates_csv),
            "output_root": output_root.as_posix(),
            "candidate_count": len(rows),
            "view_count": 6,
            "view_file_count": len(manifest),
        }
    ]


def write_csv(path: Path, rows: list[dict[str, object]]) -> None:
    assert rows
    fieldnames = list(rows[0])
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def ensure_newline(text: str) -> str:
    return text if text.endswith("\n") else text + "\n"


def line_count(text: str) -> int:
    return len(text.splitlines())


def sha256_text(text: str) -> str:
    return hashlib.sha256(text.encode("utf-8")).hexdigest()


def sha256_file(path: Path) -> str:
    hasher = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            hasher.update(chunk)
    return hasher.hexdigest()


if __name__ == "__main__":
    raise SystemExit(main())

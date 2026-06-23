#!/usr/bin/env python3
"""Run T70 source-aligned extractor smoke on generated RTL candidates."""

from __future__ import annotations

import csv
import hashlib
import json
import pickle
import re
import shutil
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import TypeAlias

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt


ROOT = Path(__file__).resolve().parents[7]
TECHNIQUE = Path(__file__).resolve().parents[1]
RUN_ROOT = (
    ROOT
    / "exp/useful_bd_push/t67_rtl_native_seeded_thought_20260623_170935_UTC"
    / "hard_tuning/rtl_native_seeded_thought_qd/seed_1001"
    / "openai_gpt-oss-120b/RTLLM"
)
OUT_ROOT = ROOT / "exp/verification/t70_generated_rtl_extractor_smoke"
MASTER_VLG2IR = ROOT / "exp/external_repos/MasterRTL/vlg2ir"
MASTER_PYTHON = ROOT / "exp/venvs/rtl_native_verify/bin/python"
RTLTIMER_LIB = (
    ROOT / "exp/external_repos/RTL-Timer/vlg2bog/scr_ys/lib/nangate45_sog.lib"
)

MODULE_RE = re.compile(r"\bmodule\s+([A-Za-z_][A-Za-z0-9_$]*)\b")
GraphMetrics: TypeAlias = dict[str, int]


@dataclass(frozen=True)
class Candidate:
    candidate_id: str
    problem: str
    kind: str
    top: str
    code_path: Path
    has_synthesis: bool


def main() -> None:
    assert RUN_ROOT.is_dir()
    assert MASTER_PYTHON.is_file()
    assert RTLTIMER_LIB.is_file()
    sys.path.insert(0, str(MASTER_VLG2IR))
    shutil.rmtree(OUT_ROOT, ignore_errors=True)
    OUT_ROOT.mkdir(parents=True)
    candidates = select_candidates()
    rows = [run_candidate(candidate) for candidate in candidates]
    write_manifest(candidates)
    write_results(rows)
    write_summary(rows)
    write_metrics(rows)
    write_figure(rows)
    write_richness_figure(rows)


def select_candidates() -> list[Candidate]:
    candidates: list[Candidate] = []
    for problem_dir in sorted(path for path in RUN_ROOT.iterdir() if path.is_dir()):
        code_paths = sorted(problem_dir.glob("Gen*/g*_thought_*/code_sample_*/code.sv"))
        assert code_paths
        first_syn = next(path for path in code_paths if synthesis_path(path).is_file())
        last_syn = next(path for path in reversed(code_paths) if synthesis_path(path).is_file())
        seen: set[Path] = set()
        for kind, path in [
            ("first_raw", code_paths[0]),
            ("first_synthesized", first_syn),
            ("last_synthesized", last_syn),
        ]:
            if path in seen:
                continue
            seen.add(path)
            index = len(candidates) + 1
            top = infer_top(path)
            candidates.append(
                Candidate(
                    candidate_id=f"t70_{index:02d}_{problem_dir.name}_{kind}",
                    problem=problem_dir.name,
                    kind=kind,
                    top=top,
                    code_path=path,
                    has_synthesis=synthesis_path(path).is_file(),
                )
            )
    return candidates


def synthesis_path(path: Path) -> Path:
    return path.parent / "code.syn.v"


def infer_top(path: Path) -> str:
    match = MODULE_RE.search(path.read_text(encoding="utf-8", errors="ignore"))
    assert match is not None
    return match.group(1)


def run_candidate(candidate: Candidate) -> dict[str, object]:
    out_dir = OUT_ROOT / candidate.candidate_id
    master_dir = out_dir / "masterrtl"
    rtltimer_dir = out_dir / "rtltimer"
    log_dir = out_dir / "logs"
    master_parse_dir = master_dir / "parse"
    for path in [master_dir, rtltimer_dir, log_dir, master_parse_dir]:
        path.mkdir(parents=True)

    master_raw = master_dir / "sog.v"
    master_clean = master_dir / "sog.clean.v"
    master_status = run_masterrtl(candidate, master_raw, master_clean, master_parse_dir, log_dir)

    rtltimer_raw = rtltimer_dir / "sog.v"
    rtltimer_clean = rtltimer_dir / "sog.clean.v"
    rtltimer_status = run_rtltimer(candidate, rtltimer_raw, rtltimer_clean, log_dir)

    row: dict[str, object] = {
        "candidate_id": candidate.candidate_id,
        "problem": candidate.problem,
        "kind": candidate.kind,
        "top": candidate.top,
        "has_synthesis": candidate.has_synthesis,
        "code_sha256": sha256(candidate.code_path),
        "code_relpath": str(candidate.code_path.relative_to(ROOT)),
        "artifact_dir": str(out_dir.relative_to(ROOT)),
    }
    row.update(master_status)
    row.update(rtltimer_status)
    return row


def run_masterrtl(
    candidate: Candidate,
    raw_path: Path,
    clean_path: Path,
    parse_dir: Path,
    log_dir: Path,
) -> dict[str, object]:
    script = (
        f"read_verilog -sv {candidate.code_path}; "
        f"hierarchy -check -top {candidate.top}; "
        "proc; flatten; opt; fsm; opt; memory; opt; techmap; opt; "
        f"write_verilog {raw_path}"
    )
    yosys = run_logged(["yosys", "-q", "-p", script], log_dir / "masterrtl_yosys")
    clean_generated_attrs(raw_path, clean_path) if yosys.returncode == 0 else None
    analyze = run_logged(
        [
            str(MASTER_PYTHON),
            "analyze.py",
            str(clean_path),
            "-N",
            candidate.candidate_id,
            "-C",
            "sog",
            "-O",
            f"{parse_dir}/",
        ],
        log_dir / "masterrtl_analyze",
        cwd=MASTER_VLG2IR,
    ) if clean_path.is_file() else None
    graph_path = parse_dir / f"{candidate.candidate_id}_sog.pkl"
    node_path = parse_dir / f"{candidate.candidate_id}_sog_node_dict.pkl"
    graph = graph_metrics(graph_path, node_path) if graph_path.is_file() else {}
    return {
        "masterrtl_yosys_ok": yosys.returncode == 0,
        "masterrtl_parse_ok": analyze is not None and analyze.returncode == 0,
        "masterrtl_graph_keys": graph.get("graph_keys", 0),
        "masterrtl_graph_edges": graph.get("graph_edges", 0),
        "masterrtl_node_dict": graph.get("node_dict", 0),
        "masterrtl_failure": failure_label(yosys, analyze),
    }


def run_rtltimer(
    candidate: Candidate,
    raw_path: Path,
    clean_path: Path,
    log_dir: Path,
) -> dict[str, object]:
    script = (
        f"read_verilog -sv {candidate.code_path}; "
        f"hierarchy -top {candidate.top}; "
        "proc; opt -fast; fsm; opt -fast; memory; opt -fast; "
        "techmap; opt -fast; rename -wire t:$*DFF*; "
        f"dfflibmap -liberty {RTLTIMER_LIB}; "
        f"abc -liberty {RTLTIMER_LIB}; clean; write_verilog {raw_path}"
    )
    yosys = run_logged(["yosys", "-q", "-p", script], log_dir / "rtltimer_yosys")
    clean_rtltimer(raw_path, clean_path) if yosys.returncode == 0 else None
    parse = run_logged(
        [
            "yosys",
            "-q",
            "-p",
            f"read_verilog {clean_path}; hierarchy -top {candidate.top}; stat",
        ],
        log_dir / "rtltimer_parse",
    ) if clean_path.is_file() else None
    counts = verilog_counts(clean_path) if clean_path.is_file() else {}
    return {
        "rtltimer_yosys_ok": yosys.returncode == 0,
        "rtltimer_parse_ok": parse is not None and parse.returncode == 0,
        "rtltimer_lines": counts.get("lines", 0),
        "rtltimer_assigns": counts.get("assigns", 0),
        "rtltimer_wires": counts.get("wires", 0),
        "rtltimer_dff_refs": counts.get("dff_refs", 0),
        "rtltimer_failure": failure_label(yosys, parse),
    }


def run_logged(
    args: list[str],
    log_prefix: Path,
    cwd: Path | None = None,
) -> subprocess.CompletedProcess[str]:
    result = subprocess.run(args, cwd=cwd, text=True, capture_output=True, check=False)
    log_prefix.with_suffix(".stdout.txt").write_text(result.stdout, encoding="utf-8")
    log_prefix.with_suffix(".stderr.txt").write_text(result.stderr, encoding="utf-8")
    log_prefix.with_suffix(".returncode.txt").write_text(f"{result.returncode}\n", encoding="utf-8")
    return result


def clean_generated_attrs(source: Path, target: Path) -> None:
    text = source.read_text(encoding="utf-8")
    target.write_text(re.sub(r"\(\*.*?\*\)", "", text, flags=re.S), encoding="utf-8")


def clean_rtltimer(source: Path, target: Path) -> None:
    cleaned = []
    for line in source.read_text(encoding="utf-8").splitlines():
        line = re.sub(r"\(\*.*\*\)", "", line)
        line = re.sub(r"/\*.*", "", line)
        if line.strip():
            cleaned.append(line)
    target.write_text("\n".join(cleaned) + "\n", encoding="utf-8")


def graph_metrics(graph_path: Path, node_path: Path) -> GraphMetrics:
    with graph_path.open("rb") as handle:
        graph = pickle.load(handle)
    with node_path.open("rb") as handle:
        node_dict = pickle.load(handle)
    return {
        "graph_keys": len(graph),
        "graph_edges": sum(len(edges) for edges in graph.values()),
        "node_dict": len(node_dict),
    }


def verilog_counts(path: Path) -> dict[str, int]:
    lines = path.read_text(encoding="utf-8").splitlines()
    return {
        "lines": len(lines),
        "assigns": count_lines(lines, r"^\s*assign\b"),
        "wires": count_lines(lines, r"^\s*wire\b"),
        "dff_refs": count_lines(lines, r"\$dff|DFF|_DFF"),
    }


def count_lines(lines: list[str], pattern: str) -> int:
    regex = re.compile(pattern)
    return sum(1 for line in lines if regex.search(line))


def failure_label(
    first: subprocess.CompletedProcess[str],
    second: subprocess.CompletedProcess[str] | None,
) -> str:
    if first.returncode != 0:
        return "yosys_failed"
    if second is None or second.returncode != 0:
        return "parse_failed"
    return "none"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    digest.update(path.read_bytes())
    return digest.hexdigest()


def write_manifest(candidates: list[Candidate]) -> None:
    path = TECHNIQUE / "tables/t70_candidate_manifest.csv"
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.writer(handle, lineterminator="\n")
        writer.writerow([
            "candidate_id",
            "problem",
            "kind",
            "top",
            "has_synthesis",
            "code_sha256",
            "code_relpath",
        ])
        for candidate in candidates:
            writer.writerow([
                candidate.candidate_id,
                candidate.problem,
                candidate.kind,
                candidate.top,
                candidate.has_synthesis,
                sha256(candidate.code_path),
                candidate.code_path.relative_to(ROOT),
            ])


def write_results(rows: list[dict[str, object]]) -> None:
    path = TECHNIQUE / "tables/t70_extractor_results.csv"
    fieldnames = list(rows[0].keys())
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def write_summary(rows: list[dict[str, object]]) -> None:
    path = TECHNIQUE / "tables/t70_extractor_summary.csv"
    kinds = sorted({str(row["kind"]) for row in rows})
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.writer(handle, lineterminator="\n")
        writer.writerow(["group", "count", "masterrtl_pass", "rtltimer_pass", "both_pass"])
        writer.writerow(summary_row("all", rows))
        for kind in kinds:
            writer.writerow(summary_row(kind, [row for row in rows if row["kind"] == kind]))


def summary_row(group: str, rows: list[dict[str, object]]) -> list[object]:
    return [
        group,
        len(rows),
        sum(1 for row in rows if row["masterrtl_parse_ok"]),
        sum(1 for row in rows if row["rtltimer_parse_ok"]),
        sum(1 for row in rows if row["masterrtl_parse_ok"] and row["rtltimer_parse_ok"]),
    ]


def write_metrics(rows: list[dict[str, object]]) -> None:
    metrics = {
        "source_run_root": str(RUN_ROOT.relative_to(ROOT)),
        "output_root": str(OUT_ROOT.relative_to(ROOT)),
        "candidate_count": len(rows),
        "masterrtl_parse_pass": sum(1 for row in rows if row["masterrtl_parse_ok"]),
        "rtltimer_parse_pass": sum(1 for row in rows if row["rtltimer_parse_ok"]),
        "both_parse_pass": sum(
            1 for row in rows if row["masterrtl_parse_ok"] and row["rtltimer_parse_ok"]
        ),
        "generated_bytes": directory_size(OUT_ROOT),
    }
    path = TECHNIQUE / "tables/t70_extractor_metrics.json"
    path.write_text(json.dumps(metrics, indent=2) + "\n", encoding="utf-8")


def directory_size(path: Path) -> int:
    return sum(file.stat().st_size for file in path.rglob("*") if file.is_file())


def write_figure(rows: list[dict[str, object]]) -> None:
    groups = ["all", "first_raw", "first_synthesized", "last_synthesized"]
    master = []
    rtltimer = []
    for group in groups:
        subset = rows if group == "all" else [row for row in rows if row["kind"] == group]
        master.append(pass_rate(subset, "masterrtl_parse_ok"))
        rtltimer.append(pass_rate(subset, "rtltimer_parse_ok"))
    x = range(len(groups))
    width = 0.36
    fig, ax = plt.subplots(figsize=(8.0, 4.2), dpi=180)
    bars_a = ax.bar([value - width / 2 for value in x], master, width, label="MasterRTL SOG")
    bars_b = ax.bar([value + width / 2 for value in x], rtltimer, width, label="RTL-Timer SOG BOG")
    ax.set_xticks(list(x), ["all", "first raw", "first synth", "last synth"])
    ax.set_ylim(0, 1.08)
    ax.set_ylabel("Parse pass rate")
    ax.set_title("T70 Generated RTL Extractor Smoke")
    ax.grid(axis="y", color="#D8D8D8", linewidth=0.7, alpha=0.75)
    ax.legend(frameon=False)
    for bars in [bars_a, bars_b]:
        for bar in bars:
            value = bar.get_height()
            ax.text(
                bar.get_x() + bar.get_width() / 2,
                value + 0.025,
                f"{value:.0%}",
                ha="center",
                va="bottom",
                fontsize=8,
            )
    for spine in ["top", "right"]:
        ax.spines[spine].set_visible(False)
    fig.tight_layout()
    fig.savefig(TECHNIQUE / "figures/t70_generated_rtl_extractor_smoke.png")


def write_richness_figure(rows: list[dict[str, object]]) -> None:
    labels = [short_label(row) for row in rows]
    master_edges = [row_int(row, "masterrtl_graph_edges") for row in rows]
    dff_refs = [row_int(row, "rtltimer_dff_refs") for row in rows]
    x = range(len(rows))
    fig, axes = plt.subplots(2, 1, figsize=(10.5, 6.4), dpi=180, sharex=True)
    axes[0].bar(x, master_edges, color="#4C78A8", width=0.72)
    axes[0].set_ylabel("MasterRTL edges")
    axes[0].set_title("T70 Extractor Output Richness By Candidate")
    axes[0].grid(axis="y", color="#D8D8D8", linewidth=0.7, alpha=0.75)
    axes[1].bar(x, dff_refs, color="#F58518", width=0.72)
    axes[1].set_ylabel("RTL-Timer DFF refs")
    axes[1].set_xticks(list(x), labels, rotation=55, ha="right", fontsize=8)
    axes[1].grid(axis="y", color="#D8D8D8", linewidth=0.7, alpha=0.75)
    for axis in axes:
        for spine in ["top", "right"]:
            axis.spines[spine].set_visible(False)
    fig.tight_layout()
    fig.savefig(TECHNIQUE / "figures/t70_extractor_richness_by_candidate.png")


def short_label(row: dict[str, object]) -> str:
    problem = str(row["problem"])
    match = re.search(r"Prob(\d+)", problem)
    assert match is not None
    kind = str(row["kind"])
    label = {
        "first_raw": "raw",
        "first_synthesized": "fsyn",
        "last_synthesized": "lsyn",
    }[kind]
    return f"P{match.group(1)} {label}"


def pass_rate(rows: list[dict[str, object]], key: str) -> float:
    assert rows
    return sum(1 for row in rows if row[key]) / len(rows)


def row_int(row: dict[str, object], key: str) -> int:
    value = row[key]
    assert isinstance(value, int)
    return value


if __name__ == "__main__":
    main()

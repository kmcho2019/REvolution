#!/usr/bin/env python3
"""Render isolated-grade JSONs into readable per-task Markdown comparison tables.

These are the AUTHORITATIVE functional verdicts for the harder benchmarks
(CVDP / RealBench), produced by isolated re-evaluation (one candidate per
process group). They supersede the in-run ``report_generator`` functional
counts, which under-report valid candidates under parallel-eval contention
(see findings M12 / M14 in ``docs/journal_features/13_findings_dashboard.md``).

Two grade schemas are supported and auto-detected per file:

* CVDP    -- ``{arm: {task: {n_total, n_checked, valid_found, any_pass}}}``
* RealBench-- ``{arm: {module: {n, valid, n_reached_sim, min_mismatch_frac,
  distinct_mismatch_fracs, sample_fracs}}}``

Multiple grade files are merged on the (disjoint) arm dimension, so a
classic/qd grade and a qd_v2 grade combine into one three-arm table.

Example::

    python scripts/render_grade_summary.py \
        --title "CVDP easy (isolated-graded)" \
        --out exp/cvdp_easy_fixed/grade_cvdp_easy_summary.md \
        exp/cvdp_easy_fixed/grade_cvdp_easy.json
"""
from __future__ import annotations

import argparse
import json
from pathlib import Path

_CAVEAT = (
    "Authoritative isolated-grade verdict (one candidate per process group). "
    "Supersedes the in-run `report_generator` functional column, which "
    "under-reports under parallel-eval contention (M12/M14)."
)


def load_merged(paths: list[str]) -> dict[str, dict]:
    """Merge per-arm grade dicts across one or more JSON files (arms are disjoint)."""
    merged: dict[str, dict] = {}
    for p in paths:
        data = json.loads(Path(p).read_text())
        for arm, tasks in data.items():
            assert arm not in merged, f"duplicate arm {arm!r} across grade files"
            merged[arm] = tasks
    return merged


def is_cvdp_schema(merged: dict[str, dict]) -> bool:
    """CVDP records carry ``any_pass``; RealBench records carry ``min_mismatch_frac``."""
    rec = next(iter(next(iter(merged.values())).values()))
    return "any_pass" in rec


def render(merged: dict[str, dict], title: str, sources: list[str]) -> str:
    """Render the merged grade dict to a Markdown report string."""
    arms = list(merged)
    tasks = sorted({t for arm in arms for t in merged[arm]})
    lines = [f"# {title}", "", _CAVEAT, "",
             "Sources: " + ", ".join(f"`{s}`" for s in sources), ""]

    if is_cvdp_schema(merged):
        lines += ["| Task | " + " | ".join(arms) + " |",
                  "|:---|" + "|".join([":--:"] * len(arms)) + "|"]
        totals = {a: 0 for a in arms}
        for t in tasks:
            cells = []
            for a in arms:
                rec = merged[a].get(t)
                if rec and rec.get("any_pass"):
                    totals[a] += 1
                    cells.append("✅ pass")
                else:
                    cells.append("❌ fail")
            lines.append(f"| {t} | " + " | ".join(cells) + " |")
        lines.append("| **Solved** | " + " | ".join(
            f"**{totals[a]}/{len(tasks)}**" for a in arms) + " |")
    else:  # RealBench mismatch schema
        lines += ["Per arm: `valid/n` functionally-valid candidates; `best` = "
                  "lowest test-vector mismatch fraction reached by any candidate "
                  "(1.0 = total failure, 0.0 = correct); `sim` = candidates that "
                  "reached simulation.", "",
                  "| Module | " + " | ".join(f"{a} valid/n" for a in arms)
                  + " | " + " | ".join(f"{a} best" for a in arms)
                  + " | " + " | ".join(f"{a} sim" for a in arms) + " |",
                  "|:---|" + "|".join([":--:"] * (3 * len(arms))) + "|"]
        totals = {a: [0, 0] for a in arms}
        for t in tasks:
            valid_cells, best_cells, sim_cells = [], [], []
            for a in arms:
                rec = merged[a].get(t)
                if rec is None:
                    valid_cells.append("—")
                    best_cells.append("—")
                    sim_cells.append("—")
                    continue
                totals[a][0] += rec["valid"]
                totals[a][1] += rec["n"]
                valid_cells.append(f"{rec['valid']}/{rec['n']}")
                best_cells.append(f"{rec['min_mismatch_frac']:.3f}")
                sim_cells.append(str(rec["n_reached_sim"]))
            lines.append(f"| {t} | " + " | ".join(valid_cells + best_cells + sim_cells) + " |")
        lines.append("| **Total valid** | " + " | ".join(
            f"**{totals[a][0]}/{totals[a][1]}**" for a in arms)
            + " | " + " | ".join(["—"] * len(arms))
            + " | " + " | ".join(["—"] * len(arms)) + " |")
    return "\n".join(lines) + "\n"


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("grade_json", nargs="+", help="One or more isolated-grade JSON files.")
    ap.add_argument("--title", required=True, help="Report H1 title.")
    ap.add_argument("--out", required=True, help="Output Markdown path.")
    args = ap.parse_args()
    merged = load_merged(args.grade_json)
    Path(args.out).write_text(render(merged, args.title, args.grade_json))
    print(f"wrote {args.out}")


if __name__ == "__main__":
    main()

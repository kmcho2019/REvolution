from __future__ import annotations

import csv
import json
from collections.abc import Iterable, Sequence
from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt


ROOT = Path(__file__).resolve().parents[7]
TECHNIQUE = Path(__file__).resolve().parents[1]
RUN_ROOT = (
    ROOT
    / "exp/useful_bd_push/t72_source_aligned_rtl_cell_20260623_204847_UTC"
    / "hard_tuning/source_aligned_rtl_cell_qd/seed_1001/openai_gpt-oss-120b"
)
T72_BOUNDS = ((4.0, 8.8), (0.0, 4.0))
T73_BOUNDS = ((0.0, 8.0), (0.0, 1.0), (0.0, 1.0))


def main() -> None:
    assert RUN_ROOT.is_dir(), f"missing T72 run root: {RUN_ROOT}"
    events = [(path, load_event(path)) for path in RUN_ROOT.rglob("qd_archive_event.json")]
    assert events, f"no qd_archive_event.json files under {RUN_ROOT}"
    t73_global_bounds = observed_bounds(t73_values(event) for _path, event in events)

    rows = []
    for problem in sorted({problem_name(path) for path, _event in events}):
        problem_events = [
            (path, event) for path, event in events if problem_name(path) == problem
        ]
        t72_cells = {bin_tuple(t72_values(event), T72_BOUNDS) for _path, event in problem_events}
        t73_values_for_problem = [t73_values(event) for _path, event in problem_events]
        t73_config_cells = {
            bin_tuple(values, T73_BOUNDS) for values in t73_values_for_problem
        }
        t73_range_cells = {
            bin_tuple(values, t73_global_bounds) for values in t73_values_for_problem
        }
        t73_quantile_cells = quantile_cells(t73_values_for_problem)
        rows.append(
            {
                "problem": problem,
                "event_count": len(problem_events),
                "t72_live_fixed_cells": len(t72_cells),
                "t73_fixed_config_cells": len(t73_config_cells),
                "t73_global_observed_range_cells": len(t73_range_cells),
                "t73_problem_local_quantile_cells": len(t73_quantile_cells),
                "log_edges_unique": unique_count(problem_events, 0),
                "state_class_unique": unique_count(problem_events, 1),
                "branching_unique": unique_count(problem_events, 2),
                "wire_density_unique": unique_count(problem_events, 3),
                "dff_density_unique": unique_count(problem_events, 4),
            }
        )

    write_problem_csv(rows)
    write_summary(rows, len(events))
    write_figure(rows)


def load_event(path: Path) -> dict:
    with path.open(encoding="utf-8") as handle:
        return json.load(handle)


def problem_name(path: Path) -> str:
    parts = path.parts
    for benchmark in ("RTLLM", "VerilogEval-Spec-to-RTL"):
        if benchmark in parts:
            index = parts.index(benchmark)
            return parts[index + 1]
    raise AssertionError(f"could not infer problem from {path}")


def t72_values(event: dict) -> tuple[float, float]:
    metrics = event["graph_metrics"]
    return (
        float(metrics["masterrtl_operator_log_edges"]),
        state_class(float(metrics["source_aligned_rtltimer_dff_refs"])),
    )


def t73_values(event: dict) -> tuple[float, float, float]:
    metrics = event["graph_metrics"]
    keys = float(metrics["source_aligned_masterrtl_graph_keys"])
    edges = float(metrics["source_aligned_masterrtl_graph_edges"])
    lines = float(metrics["source_aligned_rtltimer_lines"])
    wires = float(metrics["source_aligned_rtltimer_wires"])
    dff_refs = float(metrics["source_aligned_rtltimer_dff_refs"])
    assert keys > 0
    assert lines > 0
    return edges / keys, wires / lines, dff_refs / lines


def state_class(dff_refs: float) -> float:
    if dff_refs == 0:
        return 0.0
    if dff_refs <= 7:
        return 1.0
    if dff_refs <= 20:
        return 2.0
    return 3.0


def bin_tuple(values: tuple[float, ...], bounds: tuple[tuple[float, float], ...]) -> tuple[int, ...]:
    return tuple(bin_value(value, lower, upper) for value, (lower, upper) in zip(values, bounds, strict=True))


def observed_bounds(
    values: Iterable[tuple[float, float, float]],
) -> tuple[tuple[float, float], ...]:
    columns = list(zip(*values, strict=True))
    return tuple((min(column), max(column)) for column in columns)


def quantile_cells(values: Sequence[tuple[float, float, float]]) -> set[tuple[int, ...]]:
    columns = list(zip(*values, strict=True))
    maps = []
    for column in columns:
        unique_values = sorted(set(round(value, 12) for value in column))
        maps.append(
            {
                value: min(3, int(index * 4 / len(unique_values)))
                for index, value in enumerate(unique_values)
            }
        )
    return {
        tuple(axis_map[round(value, 12)] for axis_map, value in zip(maps, row, strict=True))
        for row in values
    }


def bin_value(value: float, lower: float, upper: float) -> int:
    if value <= lower:
        return 0
    if value >= upper:
        return 3
    return int(((value - lower) / (upper - lower)) * 4)


def unique_count(problem_events: list[tuple[Path, dict]], axis_index: int) -> int:
    values = []
    for _path, event in problem_events:
        axis_values = t72_values(event) + t73_values(event)
        values.append(round(axis_values[axis_index], 12))
    return len(set(values))


def write_problem_csv(rows: list[dict]) -> None:
    path = TECHNIQUE / "tables/t73_descriptor_collapse_audit.csv"
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def write_summary(rows: list[dict], event_count: int) -> None:
    t72_mean = mean(row["t72_live_fixed_cells"] for row in rows)
    t73_range_mean = mean(row["t73_global_observed_range_cells"] for row in rows)
    t73_quantile_mean = mean(row["t73_problem_local_quantile_cells"] for row in rows)
    summary = {
        "source_run_root": str(RUN_ROOT.relative_to(ROOT)),
        "event_count": event_count,
        "problem_count": len(rows),
        "t72_live_fixed_cells_mean": t72_mean,
        "t73_global_observed_range_cells_mean": t73_range_mean,
        "t73_problem_local_quantile_cells_mean": t73_quantile_mean,
        "t73_quantile_to_t72_cell_ratio": t73_quantile_mean / t72_mean,
        "t72_live_fixed_cells_min": min(row["t72_live_fixed_cells"] for row in rows),
        "t73_problem_local_quantile_cells_min": min(
            row["t73_problem_local_quantile_cells"] for row in rows
        ),
        "fixed_config_warning": "0..1 density bounds still collapse; use grid_quantile",
        "axis_choice": [
            "source_aligned_masterrtl_branching",
            "source_aligned_rtltimer_wire_density",
            "source_aligned_rtltimer_dff_density",
        ],
        "decision": "pre_register_t73_grid_quantile_live_screen",
    }
    path = TECHNIQUE / "tables/t73_axis_screen_summary.json"
    path.write_text(json.dumps(summary, indent=2) + "\n", encoding="utf-8")


def mean(values: Iterable[float]) -> float:
    collected = list(values)
    return sum(collected) / len(collected)


def write_figure(rows: list[dict]) -> None:
    labels = [row["problem"].replace("Prob", "P") for row in rows]
    x_values = list(range(len(rows)))
    fig, ax = plt.subplots(figsize=(11, 4.8))
    ax.bar(
        [x - 0.24 for x in x_values],
        [row["t72_live_fixed_cells"] for row in rows],
        width=0.24,
        color="#8da0cb",
        label="T72 live fixed grid",
    )
    ax.bar(
        x_values,
        [row["t73_global_observed_range_cells"] for row in rows],
        width=0.24,
        color="#fc8d62",
        label="T73 observed-range grid",
    )
    ax.bar(
        [x + 0.24 for x in x_values],
        [row["t73_problem_local_quantile_cells"] for row in rows],
        width=0.24,
        color="#66c2a5",
        label="T73 local quantile grid",
    )
    ax.set_title("T73 Shape-Density Axes Reduce T72 Descriptor Collapse")
    ax.set_ylabel("Occupied cells from T72 candidates")
    ax.set_xticks(x_values)
    ax.set_xticklabels(labels, rotation=35, ha="right")
    ax.grid(axis="y", alpha=0.25)
    ax.legend(frameon=False, loc="upper left")
    fig.tight_layout()
    fig.savefig(TECHNIQUE / "figures/t73_descriptor_occupancy_audit.png", dpi=180)
    plt.close(fig)


if __name__ == "__main__":
    main()

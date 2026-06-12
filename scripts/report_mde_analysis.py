#!/usr/bin/env python3
"""Minimum-detectable-effect (MDE) analysis for the predeclared gates.

The narrative requires an archived MDE artifact before the finals freeze:
counts may rise from it, never fall, and a gate shown infeasible drops
its claim rather than being retuned. This script estimates, by seeded
simulation faithful to the gate machinery (cluster bootstrap over
problems, CI-low > 0 criterion), the smallest true effect detectable
with the requested power at candidate (problems x seeds) scales.

Two gate families:
- continuous (best-quality / avg-PPA deltas): problem-level effects are
  drawn Normal(effect, sd_problem) with seed replicates
  Normal(0, sd_seed) on top; sd estimates come from observed
  paired_deltas.csv files (between-problem SD of mean deltas, and
  within-problem across-seed SD when multiple seeds share problems).
- binary (CVDP/RealBench pass rates): paired Bernoulli simulation with
  the penalized pass-rate delta evaluated on the cluster bootstrap.
"""

from __future__ import annotations

import argparse
import csv
import json
import random
import statistics
from collections import defaultdict
from pathlib import Path


def load_observed_deltas(paired_csv_paths: list[Path], metric: str) -> dict[str, list[float]]:
    """problem -> list of observed deltas (across seeds/pairs)."""

    by_problem: dict[str, list[float]] = defaultdict(list)
    for path in paired_csv_paths:
        for row in csv.DictReader(path.open()):
            if row.get("metric") != metric or row.get("status") != "paired":
                continue
            unit = row.get("unit_id", "")
            parts = unit.split("/")
            problem = parts[-1] if parts else unit
            try:
                by_problem[problem].append(float(row["delta"]))
            except (KeyError, ValueError):
                continue
    return dict(by_problem)


def estimate_variance(by_problem: dict[str, list[float]]) -> tuple[float, float]:
    """Return (sd_problem, sd_seed) from observed per-problem deltas."""

    means = [statistics.fmean(v) for v in by_problem.values() if v]
    sd_problem = statistics.stdev(means) if len(means) >= 2 else 0.05
    within: list[float] = []
    for values in by_problem.values():
        if len(values) >= 2:
            within.append(statistics.stdev(values))
    sd_seed = statistics.fmean(within) if within else sd_problem / 2.0
    return sd_problem, sd_seed


def _cluster_ci_low(deltas_by_problem: list[list[float]], rng: random.Random, n_boot: int) -> float:
    n = len(deltas_by_problem)
    means = []
    for _ in range(n_boot):
        total, count = 0.0, 0
        for _ in range(n):
            cluster = deltas_by_problem[rng.randrange(n)]
            total += sum(cluster)
            count += len(cluster)
        means.append(total / count)
    means.sort()
    return means[max(0, int(0.025 * n_boot))]


def power_continuous(
    *,
    effect: float,
    sd_problem: float,
    sd_seed: float,
    n_problems: int,
    n_seeds: int,
    n_sim: int,
    n_boot: int,
    seed: int,
) -> float:
    rng = random.Random(seed)
    hits = 0
    for _ in range(n_sim):
        clusters = []
        for _ in range(n_problems):
            problem_effect = rng.gauss(effect, sd_problem)
            clusters.append([problem_effect + rng.gauss(0.0, sd_seed) for _ in range(n_seeds)])
        if _cluster_ci_low(clusters, rng, n_boot) > 0.0:
            hits += 1
    return hits / n_sim


def power_binary(
    *,
    base_rate: float,
    delta: float,
    n_tasks: int,
    n_seeds: int,
    n_sim: int,
    n_boot: int,
    seed: int,
) -> float:
    rng = random.Random(seed)
    hits = 0
    treat_rate = min(1.0, base_rate + delta)
    for _ in range(n_sim):
        clusters = []
        for _ in range(n_tasks):
            cluster = [
                (1.0 if rng.random() < treat_rate else 0.0)
                - (1.0 if rng.random() < base_rate else 0.0)
                for _ in range(n_seeds)
            ]
            clusters.append(cluster)
        if _cluster_ci_low(clusters, rng, n_boot) > 0.0:
            hits += 1
    return hits / n_sim


def find_mde(power_fn, effects: list[float], target_power: float) -> tuple[float | None, dict[str, float]]:
    curve: dict[str, float] = {}
    mde: float | None = None
    for effect in effects:
        p = power_fn(effect)
        curve[f"{effect:g}"] = p
        if mde is None and p >= target_power:
            mde = effect
    return mde, curve


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--paired-csv", type=Path, action="append", default=None,
        help="paired_deltas.csv files supplying observed variance.",
    )
    parser.add_argument("--metric", default="best_quality")
    parser.add_argument("--target-power", type=float, default=0.8)
    parser.add_argument("--n-sim", type=int, default=300)
    parser.add_argument("--n-boot", type=int, default=400)
    parser.add_argument("--seed", type=int, default=20260613)
    parser.add_argument("--output-dir", type=Path, required=True)
    args = parser.parse_args(argv)

    observed = {}
    sd_problem, sd_seed = 0.05, 0.025  # conservative defaults, overridden below
    if args.paired_csv:
        observed = load_observed_deltas(args.paired_csv, args.metric)
        if observed:
            sd_problem, sd_seed = estimate_variance(observed)

    effects = [0.01, 0.02, 0.03, 0.05, 0.08, 0.12]
    continuous_scales = [(20, 5), (13, 5), (20, 3)]
    continuous = {}
    for n_problems, n_seeds in continuous_scales:
        mde, curve = find_mde(
            lambda effect, np=n_problems, ns=n_seeds: power_continuous(
                effect=effect, sd_problem=sd_problem, sd_seed=sd_seed,
                n_problems=np, n_seeds=ns,
                n_sim=args.n_sim, n_boot=args.n_boot, seed=args.seed,
            ),
            effects, args.target_power,
        )
        continuous[f"{n_problems}x{n_seeds}"] = {"mde": mde, "power_curve": curve}

    deltas = [0.05, 0.10, 0.15, 0.20]
    binary = {}
    for n_tasks, n_seeds, base in ((30, 5, 0.3), (26, 5, 0.3), (10, 5, 0.3)):
        mde, curve = find_mde(
            lambda d, nt=n_tasks, ns=n_seeds, b=base: power_binary(
                base_rate=b, delta=d, n_tasks=nt, n_seeds=ns,
                n_sim=args.n_sim, n_boot=args.n_boot, seed=args.seed,
            ),
            deltas, args.target_power,
        )
        binary[f"{n_tasks}tasks_x{n_seeds}seeds_base{base:g}"] = {
            "mde_points": mde, "power_curve": curve,
        }

    report = {
        "metric": args.metric,
        "observed_problems": len(observed),
        "sd_problem": sd_problem,
        "sd_seed": sd_seed,
        "target_power": args.target_power,
        "gate_criterion": "cluster-bootstrap 95% CI low > 0",
        "continuous_gates": continuous,
        "binary_gates": binary,
        "ratchet": "counts may rise from this analysis, never fall; an infeasible gate drops its claim",
    }
    args.output_dir.mkdir(parents=True, exist_ok=True)
    (args.output_dir / "mde_analysis.json").write_text(json.dumps(report, indent=2), encoding="utf-8")
    lines = [
        "# MDE Analysis",
        "",
        f"Variance source: {len(observed)} observed problems "
        f"(sd_problem={sd_problem:.4f}, sd_seed={sd_seed:.4f}); power target "
        f"{args.target_power:.0%}; criterion: cluster CI-low > 0.",
        "",
        "| Scale | MDE (continuous delta) |",
        "| --- | --- |",
    ]
    for scale, entry in continuous.items():
        lines.append(f"| {scale} | {entry['mde'] if entry['mde'] is not None else '> 0.12 (infeasible in grid)'} |")
    lines += ["", "| Scale | MDE (pass-rate points) |", "| --- | --- |"]
    for scale, entry in binary.items():
        mde = entry["mde_points"]
        lines.append(f"| {scale} | {f'{mde*100:.0f}pp' if mde is not None else '> 20pp (infeasible in grid)'} |")
    lines.append("")
    (args.output_dir / "mde_analysis.md").write_text("\n".join(lines), encoding="utf-8")
    print(f"sd_problem={sd_problem:.4f} sd_seed={sd_seed:.4f}")
    for scale, entry in continuous.items():
        print(f"continuous {scale}: MDE={entry['mde']}")
    for scale, entry in binary.items():
        print(f"binary {scale}: MDE={entry['mde_points']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

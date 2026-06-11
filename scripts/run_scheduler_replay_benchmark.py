#!/usr/bin/env python3
"""Scheduler replay benchmark for the journal-revamp throughput gate.

Replays one deterministic, heterogeneous evaluation workload through the real
elastic parallelism machinery (`ElasticParallelismRuntime`, problem pool,
per-batch worker leasing) under two scheduling policies:

- ``fixed``: the baseline static split — every problem gets
  ``total_worker_slots // problem_processes`` candidate workers for the whole
  run (`FixedProblemConcurrencyController`), the classic fixed per-problem
  allocation.
- ``elastic``: the production elastic policy — one base slot per active
  problem plus per-batch extra-slot leasing from the shared pool.

Both arms execute the identical seeded workload (same per-candidate latencies,
same per-generation think times) and produce a candidate-outcome digest; the
gate requires identical digests and reports the elastic wall-clock reduction
against the fixed baseline. Latencies are simulated with scaled sleeps so the
gate is a bounded smoke harness rather than a live toolchain run.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import multiprocessing
import random
import sys
import time
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
from typing import Any

import yaml

REPO_SRC = Path(__file__).resolve().parent.parent / "src"
if str(REPO_SRC) not in sys.path:
    sys.path.insert(0, str(REPO_SRC))

from revolution.runtime.parallelism import (  # noqa: E402
    ElasticParallelismRuntime,
    FixedProblemConcurrencyController,
    ProblemConcurrencyController,
    ResolvedParallelismConfig,
    build_problem_concurrency_controller,
    summarize_scheduler_telemetry,
)


def build_default_workload(seed: int) -> dict[str, Any]:
    """Build the default heterogeneous workload.

    Modeled loosely on observed evaluator behavior: most problems have short
    simulation-bound candidates, a minority have synthesis-heavy long
    candidates (heavy tail), and per-generation think time stands in for the
    LLM call between batches. All values derive from ``seed``.
    """

    rng = random.Random(seed)
    problems: list[dict[str, Any]] = []
    for index in range(8):
        heavy = index in (0, 3)  # two long-tail problems
        generations = []
        for _ in range(3):
            batch = []
            batch_size = 8 if heavy else rng.choice([4, 6, 8])
            for _ in range(batch_size):
                if heavy:
                    latency = rng.uniform(2.0, 4.0)
                else:
                    latency = rng.uniform(0.2, 0.7)
                batch.append(round(latency, 3))
            generations.append(
                {
                    "think_seconds": round(rng.uniform(0.1, 0.4), 3),
                    "candidate_seconds": batch,
                }
            )
        problems.append({"problem": f"prob_{index:02d}", "generations": generations})
    return {"version": 1, "seed": seed, "problems": problems}


def _evaluate_candidate(token: str, latency_s: float, scale: float) -> str:
    time.sleep(max(0.0, latency_s * scale))
    return hashlib.sha256(token.encode("utf-8")).hexdigest()[:16]


def _run_problem(payload: dict[str, Any]) -> dict[str, Any]:
    """Worker entry: run one problem's generations under the leasing policy."""

    problem = payload["problem"]
    generations = payload["generations"]
    scale = float(payload["scale"])
    mode = payload["mode"]
    handles = payload.get("handles")
    config: ResolvedParallelismConfig = payload["config"]

    controller: ProblemConcurrencyController
    if mode == "elastic":
        controller = build_problem_concurrency_controller(
            config, problem_id=problem, handles=handles
        )
    else:
        fixed_workers = max(1, config.total_worker_slots // max(1, config.problem_processes))
        controller = FixedProblemConcurrencyController(fixed_workers)

    outcomes: list[str] = []
    started = time.monotonic()
    controller.open_problem()
    try:
        for gen_index, generation in enumerate(generations):
            time.sleep(float(generation.get("think_seconds", 0.0)) * scale)
            latencies = [float(value) for value in generation["candidate_seconds"]]
            with controller.lease_candidate_workers(len(latencies)) as workers:
                if workers > 1 and len(latencies) > 1:
                    with ThreadPoolExecutor(max_workers=workers) as executor:
                        futures = [
                            executor.submit(
                                _evaluate_candidate,
                                f"{problem}:{gen_index}:{idx}:{latency}",
                                latency,
                                scale,
                            )
                            for idx, latency in enumerate(latencies)
                        ]
                        outcomes.extend(future.result() for future in futures)
                else:
                    outcomes.extend(
                        _evaluate_candidate(
                            f"{problem}:{gen_index}:{idx}:{latency}", latency, scale
                        )
                        for idx, latency in enumerate(latencies)
                    )
    finally:
        controller.close_problem()
    return {
        "problem": problem,
        "outcomes": outcomes,
        "problem_wall_seconds": time.monotonic() - started,
    }


def run_workload(
    workload: dict[str, Any],
    *,
    mode: str,
    total_worker_slots: int,
    max_active_problems: int | None,
    scale: float,
) -> dict[str, Any]:
    problems = workload["problems"]
    config = ResolvedParallelismConfig(
        total_worker_slots=total_worker_slots,
        max_active_problems=max_active_problems or total_worker_slots,
        max_workers_per_problem=total_worker_slots,
        problem_processes=min(
            len(problems), total_worker_slots, max_active_problems or total_worker_slots
        ),
        candidate_worker_limit=total_worker_slots,
    )
    runtime = (
        ElasticParallelismRuntime.create(config)
        if mode == "elastic" and config.problem_processes > 1
        else None
    )
    payloads = [
        {
            "problem": entry["problem"],
            "generations": entry["generations"],
            "scale": scale,
            "mode": mode,
            "handles": runtime.handles if runtime is not None else None,
            "config": config,
        }
        for entry in problems
    ]

    started = time.monotonic()
    if config.problem_processes <= 1:
        results = [_run_problem(payload) for payload in payloads]
    else:
        with multiprocessing.Pool(config.problem_processes) as pool:
            results = list(pool.imap_unordered(_run_problem, payloads))
    wall_seconds = time.monotonic() - started

    telemetry: dict[str, Any] | None = None
    if runtime is not None:
        telemetry = summarize_scheduler_telemetry(
            runtime.drain_telemetry_events(),
            total_worker_slots=config.total_worker_slots,
        )
        runtime.close()

    all_outcomes = sorted(
        outcome for result in results for outcome in result["outcomes"]
    )
    digest = hashlib.sha256("\n".join(all_outcomes).encode("utf-8")).hexdigest()
    return {
        "mode": mode,
        "wall_seconds": wall_seconds,
        "outcome_count": len(all_outcomes),
        "outcome_digest": digest,
        "problem_wall_seconds": {
            result["problem"]: result["problem_wall_seconds"] for result in results
        },
        "telemetry": telemetry,
        "parallelism_config": {
            "total_worker_slots": config.total_worker_slots,
            "problem_processes": config.problem_processes,
        },
    }


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--workload-config",
        type=Path,
        default=None,
        help="Optional workload YAML (defaults to the seeded built-in workload).",
    )
    parser.add_argument("--seed", type=int, default=42, help="Workload seed.")
    parser.add_argument("--total-worker-slots", type=int, default=16)
    parser.add_argument("--max-active-problems", type=int, default=None)
    parser.add_argument(
        "--scale",
        type=float,
        default=0.25,
        help="Latency scale factor (1.0 = modeled seconds).",
    )
    parser.add_argument(
        "--gate-percent",
        type=float,
        default=25.0,
        help="Required elastic wall-clock reduction vs the fixed baseline.",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=None,
        help="Optional JSON report output path.",
    )
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    if args.workload_config is not None:
        workload = yaml.safe_load(args.workload_config.read_text(encoding="utf-8"))
    else:
        workload = build_default_workload(args.seed)

    results = {}
    for mode in ("fixed", "elastic"):
        results[mode] = run_workload(
            workload,
            mode=mode,
            total_worker_slots=args.total_worker_slots,
            max_active_problems=args.max_active_problems,
            scale=args.scale,
        )
        print(
            f"[{mode}] wall={results[mode]['wall_seconds']:.2f}s "
            f"outcomes={results[mode]['outcome_count']} "
            f"digest={results[mode]['outcome_digest'][:12]}"
        )

    fixed_wall = results["fixed"]["wall_seconds"]
    elastic_wall = results["elastic"]["wall_seconds"]
    outcomes_match = (
        results["fixed"]["outcome_digest"] == results["elastic"]["outcome_digest"]
    )
    improvement_percent = (
        (fixed_wall - elastic_wall) / fixed_wall * 100.0 if fixed_wall > 0 else 0.0
    )
    gate_passed = outcomes_match and improvement_percent >= args.gate_percent

    report = {
        "workload_seed": workload.get("seed"),
        "scale": args.scale,
        "total_worker_slots": args.total_worker_slots,
        "fixed": results["fixed"],
        "elastic": results["elastic"],
        "outcomes_match": outcomes_match,
        "improvement_percent": improvement_percent,
        "gate_percent": args.gate_percent,
        "gate_passed": gate_passed,
    }
    if args.output is not None:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(json.dumps(report, indent=2), encoding="utf-8")
        print(f"Report written to {args.output}")

    print(
        f"Scheduler gate: improvement={improvement_percent:.1f}% "
        f"(required {args.gate_percent:.1f}%), outcomes_match={outcomes_match} -> "
        f"{'PASS' if gate_passed else 'FAIL'}"
    )
    return 0 if gate_passed else 1


if __name__ == "__main__":
    raise SystemExit(main())

#!/usr/bin/env python3
from __future__ import annotations

import argparse
import datetime as dt
import os
import shlex
import subprocess
import sys
from pathlib import Path
from typing import Any

PROJECT_ROOT = Path(__file__).resolve().parents[1]
if str(PROJECT_ROOT / "src") not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT / "src"))

from revolution.prompt_tuning import (  # noqa: E402
    JOURNAL_THOUGHT_ONLY_KEYS,
    PROXY_PROBLEMS,
    ProxySettings,
    as_jsonable,
    changed_prompt_sections,
    export_prompt_bundle,
    load_env_file,
    materialize_prompt_profile,
    parse_prompt_bundle,
    preflight_rtl_vllm,
    render_campaign_markdown,
    require_prompt_tuning_dependencies,
    run_proxy_evaluation,
    score_run_root,
    write_json,
)


DEFAULT_SAVE_ROOT = PROJECT_ROOT / "exp" / "gepa_prompt_tuning"
DEFAULT_PROMPT_ROOT = PROJECT_ROOT / "data" / "prompts"


def _parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Run GEPA prompt tuning over a concatenated PromptStore profile bundle."
    )
    parser.add_argument("--prompt-root", type=Path, default=DEFAULT_PROMPT_ROOT)
    parser.add_argument("--baseline-profile", default="journal_thought_only")
    parser.add_argument("--optimized-profile", default="journal_thought_only_gepa")
    parser.add_argument("--save-root", type=Path, default=DEFAULT_SAVE_ROOT)
    parser.add_argument("--optimizer-model", default="gpt-5.5")
    parser.add_argument("--max-metric-calls", type=int, default=3)
    parser.add_argument("--seed", type=int, default=42)
    parser.add_argument("--overwrite-optimized-profile", action="store_true")
    parser.add_argument(
        "--evaluator-command",
        default=None,
        help=(
            "Optional explicit evaluator command. Supports {prompt_root}, "
            "{prompt_profile}, {run_root}, and {candidate_id} placeholders."
        ),
    )
    parser.add_argument("--vllm-host", default="host.docker.internal")
    parser.add_argument("--vllm-port", type=int, default=8000)
    parser.add_argument("--vllm-min-model-len", type=int, default=128000)
    parser.add_argument("--vllm-preflight-timeout-s", type=float, default=5.0)
    return parser.parse_args(argv)


def _candidate_bundle(candidate: dict[str, str] | str) -> str:
    if isinstance(candidate, str):
        return candidate
    bundle = candidate.get("prompt_bundle")
    if not isinstance(bundle, str):
        raise ValueError("GEPA candidate missing prompt_bundle")
    return bundle


def _run_evaluator_command(
    command_template: str,
    *,
    prompt_root: Path,
    prompt_profile: str,
    run_root: Path,
    candidate_id: str,
) -> None:
    command = [
        item.format(
            prompt_root=str(prompt_root),
            prompt_profile=prompt_profile,
            run_root=str(run_root),
            candidate_id=candidate_id,
        )
        for item in shlex.split(command_template)
    ]
    completed = subprocess.run(command, cwd=PROJECT_ROOT, text=True)
    if completed.returncode != 0:
        raise RuntimeError(
            f"Evaluator command failed with exit code {completed.returncode}: {command}"
        )


def _write_candidate_report(
    candidate_dir: Path,
    row: dict[str, Any],
    score_payload: dict[str, Any],
) -> None:
    write_json(candidate_dir / "score.json", score_payload)
    lines = [
        "# GEPA Candidate Report",
        "",
        f"- Candidate: `{row['candidate_id']}`",
        f"- Status: `{row['status']}`",
        f"- Score: `{row['score']:.4f}`",
        f"- Bundle hash: `{row['bundle_hash']}`",
        f"- Run root: `{row['run_root']}`",
        "",
        "## Changed Sections",
        "",
    ]
    changed = row.get("changed_sections", [])
    lines.extend(f"- `{section}`" for section in changed) if changed else lines.append("- none")
    lines.extend(["", "## Errors", ""])
    errors = row.get("errors", [])
    lines.extend(f"- {error}" for error in errors) if errors else lines.append("- none")
    lines.append("")
    (candidate_dir / "report.md").write_text("\n".join(lines), encoding="utf-8")


def _build_gepa_config(args: argparse.Namespace, campaign_root: Path):
    from gepa.optimize_anything import EngineConfig, GEPAConfig, ReflectionConfig

    return GEPAConfig(
        engine=EngineConfig(
            run_dir=str(campaign_root / "gepa_state"),
            seed=args.seed,
            max_metric_calls=args.max_metric_calls,
            max_candidate_proposals=args.max_metric_calls,
            parallel=False,
            cache_evaluation=False,
            display_progress_bar=False,
            raise_on_exception=True,
        ),
        reflection=ReflectionConfig(
            reflection_lm=args.optimizer_model,
            reflection_minibatch_size=1,
            module_selector="all",
            skip_perfect_score=False,
        ),
        refiner=None,
    )


def run_campaign(args: argparse.Namespace) -> dict[str, Any]:
    if args.max_metric_calls < 1:
        raise ValueError("--max-metric-calls must be >= 1")
    load_env_file()
    if not os.environ.get("OPENAI_API_KEY"):
        raise RuntimeError("OPENAI_API_KEY is not set after loading /workspace/.env")
    versions = require_prompt_tuning_dependencies()

    ts = dt.datetime.now().strftime("%Y%m%d_%H%M%S")
    campaign_root = args.save_root.resolve() / ts
    bundle_dir = campaign_root / "bundles"
    temp_prompt_root = campaign_root / "prompt_profiles"
    candidate_runs = campaign_root / "candidate_runs"
    bundle_dir.mkdir(parents=True)
    temp_prompt_root.mkdir(parents=True)
    candidate_runs.mkdir(parents=True)

    baseline = export_prompt_bundle(
        args.prompt_root.resolve(),
        args.baseline_profile,
        JOURNAL_THOUGHT_ONLY_KEYS,
    )
    (bundle_dir / "seed_prompt_bundle.txt").write_text(baseline.text, encoding="utf-8")

    settings = ProxySettings(
        seed=args.seed,
        vllm_host=args.vllm_host,
        vllm_port=args.vllm_port,
        vllm_min_model_len=args.vllm_min_model_len,
        vllm_preflight_timeout_s=args.vllm_preflight_timeout_s,
    )
    model_name = "external_evaluator"
    if args.evaluator_command is None:
        model_name = preflight_rtl_vllm(settings)
    elif not args.evaluator_command.strip():
        raise ValueError("--evaluator-command cannot be empty")

    candidate_rows: list[dict[str, Any]] = []
    counter = {"value": 0}

    def evaluate(candidate: dict[str, str]) -> tuple[float, dict[str, Any]]:
        counter["value"] += 1
        candidate_id = f"cand_{counter['value']:03d}"
        candidate_dir = campaign_root / "candidates" / candidate_id
        candidate_dir.mkdir(parents=True)
        run_root = candidate_runs / candidate_id
        profile = f"{args.optimized_profile}_{candidate_id}"
        row: dict[str, Any] = {
            "candidate_id": candidate_id,
            "status": "failed",
            "score": 0.0,
            "bundle_hash": "",
            "bundle_path": str(candidate_dir / "prompt_bundle.txt"),
            "profile": profile,
            "profile_path": str(temp_prompt_root / profile),
            "run_root": str(run_root),
            "changed_sections": [],
            "errors": [],
            "warnings": [],
        }
        try:
            bundle_text = _candidate_bundle(candidate)
            sections = parse_prompt_bundle(bundle_text, JOURNAL_THOUGHT_ONLY_KEYS)
            bundle = materialize_prompt_profile(
                prompt_root=temp_prompt_root,
                profile=profile,
                bundle_text=bundle_text,
                overwrite=True,
            )
            (candidate_dir / "prompt_bundle.txt").write_text(bundle.text, encoding="utf-8")
            row["bundle_hash"] = bundle.sha256
            row["changed_sections"] = changed_prompt_sections(
                baseline.sections,
                sections,
            )
            if args.evaluator_command:
                _run_evaluator_command(
                    args.evaluator_command,
                    prompt_root=temp_prompt_root,
                    prompt_profile=profile,
                    run_root=run_root,
                    candidate_id=candidate_id,
                )
            else:
                run_proxy_evaluation(
                    repo_root=PROJECT_ROOT,
                    prompt_root=temp_prompt_root,
                    prompt_profile=profile,
                    run_root=run_root,
                    settings=settings,
                    model_name=model_name,
                )
            score = score_run_root(run_root, PROXY_PROBLEMS)
            row["status"] = score.status
            row["score"] = score.scalar_score
            row["errors"] = score.errors
            row["warnings"] = score.warnings
            score_payload = as_jsonable(score)
        except Exception as exc:
            row["errors"] = [str(exc)]
            score_payload = {"status": "failed", "errors": row["errors"]}
        candidate_rows.append(row)
        _write_candidate_report(candidate_dir, row, score_payload)
        return float(row["score"]), {
            "candidate_id": candidate_id,
            "status": row["status"],
            "errors": row["errors"],
            "warnings": row["warnings"],
            "run_root": row["run_root"],
            "score": row["score"],
        }

    from gepa.optimize_anything import optimize_anything

    result = optimize_anything(
        seed_candidate={"prompt_bundle": baseline.text},
        evaluator=evaluate,
        objective=(
            "Improve the PromptStore bundle for thought-only RTL QD search. "
            "Return the same concat bundle format and preserve every required "
            "prompt section marker exactly."
        ),
        background=(
            "The bundle is split back into PromptStore files and evaluated with "
            "grid_quantile_pareto_journal_thought_k4 on four hard proxy RTL "
            "problems. Missing sections, duplicate sections, malformed bundles, "
            "or zero valid-PPA proxy problems receive score zero."
        ),
        config=_build_gepa_config(args, campaign_root),
    )

    best = result.best_candidate
    best_bundle_text = _candidate_bundle(best)
    final_bundle = materialize_prompt_profile(
        prompt_root=args.prompt_root.resolve(),
        profile=args.optimized_profile,
        bundle_text=best_bundle_text,
        overwrite=args.overwrite_optimized_profile,
    )
    final_bundle_path = bundle_dir / "selected_prompt_bundle.txt"
    final_bundle_path.write_text(final_bundle.text, encoding="utf-8")
    selected_row = max(candidate_rows, key=lambda row: float(row.get("score", 0.0)))
    selected = {
        "candidate_id": selected_row["candidate_id"],
        "bundle_hash": final_bundle.sha256,
        "bundle_path": str(final_bundle_path),
        "profile_path": str(args.prompt_root.resolve() / args.optimized_profile),
        "score": selected_row["score"],
    }
    payload = {
        "campaign_root": str(campaign_root),
        "baseline_profile": args.baseline_profile,
        "optimized_profile": args.optimized_profile,
        "optimizer_model": args.optimizer_model,
        "dependency_versions": versions,
        "proxy_settings": as_jsonable(settings),
        "proxy_problems": [
            {"benchmark": benchmark, "problem": problem}
            for benchmark, problem in PROXY_PROBLEMS
        ],
        "baseline_bundle_hash": baseline.sha256,
        "selected_candidate": selected,
        "candidates": candidate_rows,
        "gepa_result": result.to_dict(),
    }
    write_json(campaign_root / "campaign.json", payload)
    (campaign_root / "campaign.md").write_text(
        render_campaign_markdown(payload),
        encoding="utf-8",
    )
    return payload


def main(argv: list[str] | None = None) -> int:
    payload = run_campaign(_parse_args(argv))
    print(f"Wrote {payload['campaign_root']}/campaign.json")
    print(f"Wrote {payload['campaign_root']}/campaign.md")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

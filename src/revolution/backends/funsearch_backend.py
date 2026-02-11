from __future__ import annotations

import asyncio
import datetime as dt
import json
import random
import time
import uuid
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

import numpy as np

from revolution.backends.base import (
    BackendExecutionContext,
    BackendRunResult,
    BackendServices,
    EvolutionBackend,
)
from revolution.prompt_store import safe_format
from revolution.runtime import CandidateEvaluation, CandidateEvaluator, CandidateWorkItem
from revolution.runtime.run_artifacts import add_legacy_strategy_key_alias


def _softmax(values: np.ndarray, temperature: float) -> np.ndarray:
    if values.size == 0:
        return np.array([], dtype=np.float64)
    temp = max(float(temperature), 1e-6)
    scaled = values / temp
    scaled = scaled - np.max(scaled)
    exps = np.exp(scaled)
    denom = np.sum(exps)
    if denom <= 0:
        return np.full(values.shape, 1.0 / values.size, dtype=np.float64)
    probs = exps / denom
    # Keep probabilities numerically normalized.
    idx = int(np.argmax(probs))
    probs[idx] = 1.0 - float(np.sum(probs[:idx])) - float(np.sum(probs[idx + 1 :]))
    return probs


@dataclass(frozen=True)
class FunSearchBackendConfig:
    initial_population_size: int = 4
    samples_per_prompt: int = 1
    num_islands: int = 10
    functions_per_prompt: int = 2
    reset_period_seconds: int = 4 * 60 * 60
    cluster_sampling_temperature_init: float = 0.1
    cluster_sampling_temperature_period: int = 30_000
    program_sampling_temperature: float = 1.0
    max_evaluations: int | None = None
    max_iterations: int | None = None
    max_runtime_seconds: float | None = None
    max_llm_calls: int | None = None
    max_llm_tokens: int | None = None
    default_llm_temp: float = 1.0
    default_llm_top_p: float = 0.95
    default_llm_max_tokens: int = 2048
    prompt_profile: str = "funsearch"
    prompt_root: str | None = None
    strict_prompt_keys: bool = True
    allow_diff_mode: bool = False
    score_reducer: str = "last_input"
    failed_candidate_bucket_score: float = -1e6
    feedback_policy: str = "off"
    feedback_sample_probability: float = 1.0
    seed: int | None = None
    candidate_workers: int = 0


@dataclass
class FunSearchCandidate:
    id: str
    generation: int
    thought: str
    code: str
    code_file_path: str
    status: str
    score: float
    cluster_score: float
    signature: tuple[float, ...]
    island_id: int | None
    ppa_metrics: dict[str, float] = field(default_factory=dict)
    feedback: str = ""
    parent_ids: list[str] = field(default_factory=list)


@dataclass
class _Cluster:
    score: float
    candidates: list[FunSearchCandidate] = field(default_factory=list)
    lengths: list[int] = field(default_factory=list)

    def register(self, candidate: FunSearchCandidate) -> None:
        self.candidates.append(candidate)
        self.lengths.append(len(candidate.code))

    def sample(self, rng: np.random.Generator, temperature: float) -> FunSearchCandidate:
        if len(self.candidates) == 1:
            return self.candidates[0]
        lengths = np.array(self.lengths, dtype=np.float64)
        normalized_lengths = (lengths - np.min(lengths)) / (np.max(lengths) + 1e-6)
        probs = _softmax(-normalized_lengths, temperature=temperature)
        return self.candidates[int(rng.choice(len(self.candidates), p=probs))]


@dataclass
class _Island:
    clusters: dict[tuple[float, ...], _Cluster] = field(default_factory=dict)
    num_programs: int = 0
    best_candidate: FunSearchCandidate | None = None
    best_cluster_score: float = float("-inf")

    def register(self, candidate: FunSearchCandidate) -> None:
        cluster = self.clusters.get(candidate.signature)
        if cluster is None:
            cluster = _Cluster(score=candidate.cluster_score)
            self.clusters[candidate.signature] = cluster
        cluster.register(candidate)
        self.num_programs += 1
        if candidate.cluster_score > self.best_cluster_score:
            self.best_cluster_score = candidate.cluster_score
            self.best_candidate = candidate


@dataclass
class _PreparedCandidate:
    generation: int
    island_id: int | None
    thought: str
    code: str
    initial_status: str
    parent_ids: list[str]
    code_file_path: str


class FunSearchBackend(EvolutionBackend):
    """FunSearch-style evolutionary backend adapted for RTL candidates."""
    # Provenance note:
    # Core algorithmic mechanics (islands, signature clustering, Boltzmann
    # sampling, and weakest-island reset/reseed) are reimplemented based on the
    # Apache-2.0 FunSearch reference under:
    # ablation/funcsearch/funsearch/implementation/programs_database.py
    # This file is a native RTL adaptation for REvolution backends.

    REQUIRED_PROMPT_KEYS = (
        "system/whole",
        "feedback/system",
        "feedback/user",
        "funsearch/prompt_header",
        "funsearch/program_block",
        "funsearch/prompt_footer",
        "funsearch/eval_feedback_suffix",
    )

    def __init__(
        self,
        context: BackendExecutionContext,
        services: BackendServices,
        config: FunSearchBackendConfig,
    ) -> None:
        self.context = context
        self.services = services
        self.config = config
        self._rng = np.random.default_rng(config.seed)
        self._islands: list[_Island] = []
        self._best_candidate: FunSearchCandidate | None = None
        self._reset_events: list[dict[str, Any]] = []
        self._generation_stats: list[dict[str, Any]] = []
        self._summary_cache: dict[str, Any] | None = None
        self._start_time: float = 0.0
        self._start_utc: dt.datetime | None = None
        self._evaluations_done: int = 0
        self._iterations_done: int = 0
        self._last_reset_time: float = 0.0
        self._total_llm_usage: dict[str, int] = {
            "api_calls": 0,
            "prompt_tokens": 0,
            "completion_tokens": 0,
            "code_prompt_tokens": 0,
            "code_completion_tokens": 0,
            "feedback_prompt_tokens": 0,
            "feedback_completion_tokens": 0,
        }
        self._status_counts: dict[str, int] = {}
        self._prompt_cache: dict[str, str] = {}
        self._signature_keys_seen: set[str] = set()

    @property
    def name(self) -> str:
        return "funsearch"

    def _load_prompt(self, key: str) -> str:
        value = self.services.prompt_store.read(key)
        if value is None:
            abs_path = self.services.prompt_store._abs_path_for(key)
            raise FileNotFoundError(
                f"Missing required FunSearch prompt key '{key}' at '{abs_path}'."
            )
        self._prompt_cache[key] = value
        return value

    def _validate_prompt_profile(self) -> None:
        if not self.config.strict_prompt_keys:
            return
        missing: list[str] = []
        for key in self.REQUIRED_PROMPT_KEYS:
            if not self.services.prompt_store.has(key):
                missing.append(f"{key} -> {self.services.prompt_store._abs_path_for(key)}")
        if missing:
            formatted = "\n".join(missing)
            raise FileNotFoundError(
                f"FunSearch prompt profile validation failed. Missing keys:\n{formatted}"
            )

    def _read_reference_ppa_metrics(self) -> dict[str, float]:
        ref_ppa_file = (
            self.context.problem_context.benchmark_path
            / f"{self.context.problem_name}_ppa.txt"
        )
        if not ref_ppa_file.is_file():
            return {}
        lines = ref_ppa_file.read_text(encoding="utf-8").splitlines()
        if len(lines) < 2:
            return {}
        values = lines[1].split(",")
        if len(values) < 5:
            return {}
        try:
            power = float(values[3])
            area = float(values[4])
            eff = float(values[2])
        except ValueError:
            return {}
        if power == 0.0 or area == 0.0:
            return {}
        return {
            "tns": float(values[0]),
            "wns": float(values[1]),
            "eff_clk_period": eff,
            "power": power,
            "area": area,
        }

    def initialize(self) -> None:
        if self.context.generation_mode != "whole" and not self.config.allow_diff_mode:
            raise ValueError(
                "FunSearch backend v1 only supports whole generation mode. "
                "Set --generation_mode whole or pass --allow_diff_mode."
            )
        if self.config.feedback_policy not in {"off", "fail_only", "always"}:
            raise ValueError(
                f"Unsupported feedback_policy '{self.config.feedback_policy}'. "
                "Expected off, fail_only, or always."
            )
        self._validate_prompt_profile()
        random.seed(self.config.seed)
        np.random.seed(self.config.seed if self.config.seed is not None else None)
        self._islands = [_Island() for _ in range(self.config.num_islands)]
        self._start_time = time.time()
        self._start_utc = dt.datetime.now(dt.timezone.utc)
        self._last_reset_time = self._start_time
        ref_ppa = self._read_reference_ppa_metrics()
        if self.services.candidate_evaluator is None:
            self.services.candidate_evaluator = CandidateEvaluator(
                context=self.context.problem_context,
                problem_description=self.context.problem_context.problem_description,
                verilog_evaluator=self.services.verilog_evaluator,
                synthesis_evaluator=self.services.synthesis_evaluator,
                ref_ppa_metrics=ref_ppa,
            )

    def _consume_llm_usage(self) -> dict[str, int]:
        usage = asyncio.run(self.services.llm.get_and_reset_usage_stats())
        for key, value in usage.items():
            self._total_llm_usage[key] = self._total_llm_usage.get(key, 0) + int(value)
        return usage

    def _record_status(self, status: str) -> None:
        self._status_counts[status] = self._status_counts.get(status, 0) + 1

    def _check_budget_exhausted(self) -> tuple[bool, str]:
        elapsed = time.time() - self._start_time
        total_tokens = self._total_llm_usage["prompt_tokens"] + self._total_llm_usage["completion_tokens"]
        if (
            self.config.max_runtime_seconds is not None
            and elapsed >= self.config.max_runtime_seconds
        ):
            return True, "max_runtime_seconds"
        if (
            self.config.max_iterations is not None
            and self._iterations_done >= self.config.max_iterations
        ):
            return True, "max_iterations"
        if (
            self.config.max_evaluations is not None
            and self._evaluations_done >= self.config.max_evaluations
        ):
            return True, "max_evaluations"
        if (
            self.config.max_llm_calls is not None
            and self._total_llm_usage["api_calls"] >= self.config.max_llm_calls
        ):
            return True, "max_llm_calls"
        if (
            self.config.max_llm_tokens is not None
            and total_tokens >= self.config.max_llm_tokens
        ):
            return True, "max_llm_tokens"
        return False, ""

    def _build_scores_per_test(self, evaluation: CandidateEvaluation) -> dict[str, float]:
        """Builds a deterministic score vector used for reducer + signature logic."""
        scores_per_test: dict[str, float] = {
            "format": float(evaluation.stage_statuses.get("format", False)),
            "diff": float(evaluation.stage_statuses.get("diff", False)),
            "syntax": float(evaluation.stage_statuses.get("syntax", False)),
            "functionality": float(evaluation.stage_statuses.get("functionality", False)),
            "synthesis": float(evaluation.stage_statuses.get("synthesis", False)),
            "synthesis_functionality": float(
                evaluation.stage_statuses.get("synthesis_functionality", False)
            ),
            "ppa": float(evaluation.stage_statuses.get("ppa", False)),
        }
        if evaluation.mismatch_count is not None:
            scores_per_test["mismatch_pass"] = float(evaluation.mismatch_count == 0)
        if evaluation.score_components:
            for key in sorted(evaluation.score_components):
                value = float(evaluation.score_components[key])
                if not np.isfinite(value):
                    value = self.config.failed_candidate_bucket_score
                scores_per_test[f"score_component/{key}"] = value
        fitness = (
            float(evaluation.score)
            if np.isfinite(evaluation.score)
            else self.config.failed_candidate_bucket_score
        )
        # Keep the fitness field last to preserve the reference-style "last_input" reducer.
        scores_per_test["fitness"] = fitness
        return scores_per_test

    def _reduce_score(self, evaluation_score: float, scores_per_test: dict[str, float]) -> float:
        reducer = self.config.score_reducer
        if reducer == "fitness":
            return float(scores_per_test.get("fitness", evaluation_score))
        if reducer == "mean":
            values = list(scores_per_test.values())
            return float(np.mean(values)) if values else evaluation_score
        if reducer == "last_input":
            if not scores_per_test:
                return evaluation_score
            return float(list(scores_per_test.values())[-1])
        raise ValueError(
            f"Unsupported score reducer '{reducer}'. Expected one of: last_input, mean, fitness."
        )

    def _cluster_signature(self, scores_per_test: dict[str, float]) -> tuple[float, ...]:
        # Match FunSearch's canonicalized signature style by sorting score keys.
        signature = []
        for key in sorted(scores_per_test):
            value = scores_per_test[key]
            if not np.isfinite(value):
                value = self.config.failed_candidate_bucket_score
            signature.append(round(float(value), 3))
        return tuple(signature)

    def _register_candidate(self, candidate: FunSearchCandidate, island_id: int | None) -> None:
        if island_id is None:
            for island in self._islands:
                island.register(candidate)
        else:
            self._islands[island_id].register(candidate)

        if self._best_candidate is None:
            self._best_candidate = candidate
            return
        if candidate.score > self._best_candidate.score:
            self._best_candidate = candidate

    def _sample_prompt_candidates(self, island_id: int) -> list[FunSearchCandidate]:
        island = self._islands[island_id]
        if not island.clusters:
            return []
        signatures = list(island.clusters.keys())
        cluster_scores = np.array(
            [island.clusters[signature].score for signature in signatures],
            dtype=np.float64,
        )
        period = max(1, self.config.cluster_sampling_temperature_period)
        temperature = self.config.cluster_sampling_temperature_init * (
            1 - (island.num_programs % period) / period
        )
        probs = _softmax(cluster_scores, temperature=max(temperature, 1e-6))
        num_to_sample = min(len(signatures), self.config.functions_per_prompt)
        cluster_indices = self._rng.choice(
            len(signatures),
            size=num_to_sample,
            replace=True,
            p=probs,
        )
        selected: list[FunSearchCandidate] = []
        for idx in cluster_indices:
            cluster = island.clusters[signatures[int(idx)]]
            selected.append(
                cluster.sample(self._rng, temperature=self.config.program_sampling_temperature)
            )
        selected.sort(key=lambda candidate: candidate.cluster_score)
        return selected

    def _build_funsearch_prompt(
        self,
        sampled: list[FunSearchCandidate],
    ) -> str:
        header = self._prompt_cache.get("funsearch/prompt_header") or self._load_prompt(
            "funsearch/prompt_header"
        )
        program_block = self._prompt_cache.get(
            "funsearch/program_block"
        ) or self._load_prompt("funsearch/program_block")
        footer = self._prompt_cache.get("funsearch/prompt_footer") or self._load_prompt(
            "funsearch/prompt_footer"
        )

        format_contract = {
            "format": "eoh_v1",
            "mode": "whole",
            "thought": "<brief strategy>",
            "code": "<complete verilog module>",
        }
        scoring_rubric = (
            "Prioritize functionality and synthesizability first, then optimize area/power/timing."
        )
        sampled_programs = [
            {
                "version": f"v{idx}",
                "score": candidate.cluster_score,
                "status": candidate.status,
                "thought": candidate.thought,
                "code": candidate.code,
            }
            for idx, candidate in enumerate(sampled)
        ]
        sampled_programs_json = json.dumps(sampled_programs, indent=2)
        target_version = f"v{len(sampled)}"
        blocks = []
        for idx, candidate in enumerate(sampled):
            blocks.append(
                safe_format(
                    program_block,
                    version=f"v{idx}",
                    score=f"{candidate.cluster_score:.6f}",
                    status=candidate.status,
                    thought=candidate.thought,
                    code=candidate.code,
                )
            )
        return "\n\n".join(
            [
                safe_format(
                    header,
                    problem_description=self.context.problem_context.problem_description,
                    sampled_programs_json=sampled_programs_json,
                    target_version=target_version,
                    scoring_rubric=scoring_rubric,
                    format_contract=json.dumps(format_contract, indent=2),
                ),
                *blocks,
                safe_format(
                    footer,
                    problem_description=self.context.problem_context.problem_description,
                    sampled_programs_json=sampled_programs_json,
                    target_version=target_version,
                    scoring_rubric=scoring_rubric,
                    format_contract=json.dumps(format_contract, indent=2),
                ),
            ]
        )

    def _write_feedback_file(self, code_file_path: str, feedback_data: dict[str, Any]) -> None:
        base = str(code_file_path).rsplit(".", 1)[0]
        output = (
            f"Score: {feedback_data.get('score', 'N/A')}\n"
            f"Justification: {feedback_data.get('justification', 'N/A')}\n\n"
            f"ANALYSIS:\n{feedback_data.get('analysis', '')}"
        )
        Path(f"{base}_feedback.txt").write_text(output, encoding="utf-8")

    def _maybe_generate_feedback(self, candidate: FunSearchCandidate, payload: dict[str, str] | None) -> None:
        if self.config.feedback_policy == "off" or payload is None:
            return
        if self.config.feedback_policy == "fail_only" and candidate.status == "success":
            return
        if random.random() > self.config.feedback_sample_probability:
            return
        system_prompt = self._prompt_cache.get("feedback/system") or self._load_prompt(
            "feedback/system"
        )
        user_template = self._prompt_cache.get("feedback/user") or self._load_prompt(
            "feedback/user"
        )
        user_prompt = safe_format(
            user_template,
            problem_def=payload.get("problem_def", ""),
            code=payload.get("code", ""),
            simulation_log=payload.get("simulation_log", ""),
        )
        suffix = self._prompt_cache.get(
            "funsearch/eval_feedback_suffix"
        ) or self._load_prompt("funsearch/eval_feedback_suffix")
        user_prompt = f"{user_prompt}\n\n{suffix}"
        feedback = asyncio.run(
            self.services.llm.generate_batch_feedback(
                [payload],
                self.config.default_llm_temp,
                self.config.default_llm_top_p,
                self.config.default_llm_max_tokens,
                system_prompt_override=[system_prompt],
                user_prompt_override=[user_prompt],
            )
        )[0]
        candidate.feedback = str(feedback.get("analysis", ""))
        self._write_feedback_file(candidate.code_file_path, feedback)
        self._consume_llm_usage()

    def _prepare_candidate(
        self,
        *,
        generation: int,
        island_id: int | None,
        thought: str,
        code: str,
        initial_status: str,
        parent_ids: list[str],
    ) -> _PreparedCandidate:
        label = f"sample{self._evaluations_done + 1}_{uuid.uuid4().hex[:8]}_funsearch"
        code_path, _ = self.services.artifact_writer.write_candidate(
            generation=generation,
            label=label,
            code=code,
            thought=thought,
            metadata={"island_id": island_id, "parent_ids": parent_ids},
        )
        return _PreparedCandidate(
            generation=generation,
            island_id=island_id,
            thought=thought,
            code=code,
            initial_status=initial_status,
            parent_ids=parent_ids,
            code_file_path=code_path,
        )

    def _finalize_candidate(
        self,
        prepared: _PreparedCandidate,
        evaluation: CandidateEvaluation,
    ) -> FunSearchCandidate:
        self._evaluations_done += 1
        self._record_status(evaluation.status)

        scores_per_test = self._build_scores_per_test(evaluation)
        self._signature_keys_seen.update(scores_per_test.keys())
        reduced = self._reduce_score(float(evaluation.score), scores_per_test)
        if not np.isfinite(reduced):
            reduced = self.config.failed_candidate_bucket_score
        signature = self._cluster_signature(scores_per_test)
        candidate = FunSearchCandidate(
            id=str(uuid.uuid4()),
            generation=prepared.generation,
            thought=prepared.thought,
            code=prepared.code,
            code_file_path=prepared.code_file_path,
            status=evaluation.status,
            score=float(evaluation.score),
            cluster_score=float(reduced),
            signature=signature,
            island_id=prepared.island_id,
            ppa_metrics=evaluation.ppa_metrics,
            feedback=str(evaluation.feedback_payload.get("simulation_log", ""))
            if evaluation.feedback_payload
            else "",
            parent_ids=prepared.parent_ids,
        )
        self._register_candidate(candidate, island_id=prepared.island_id)
        self._reset_islands_if_needed()
        self._maybe_generate_feedback(candidate, evaluation.feedback_payload)
        return candidate

    def _evaluate_and_register_batch(
        self,
        prepared_candidates: list[_PreparedCandidate],
    ) -> list[FunSearchCandidate]:
        if not prepared_candidates:
            return []
        work_item = CandidateWorkItem(
            code=prepared_candidates[0].code,
            code_file_path=prepared_candidates[0].code_file_path,
            initial_status=prepared_candidates[0].initial_status,
        )
        assert self.services.candidate_evaluator is not None
        items = [work_item]
        for prepared in prepared_candidates[1:]:
            items.append(
                CandidateWorkItem(
                    code=prepared.code,
                    code_file_path=prepared.code_file_path,
                    initial_status=prepared.initial_status,
                )
            )
        evaluations = self.services.candidate_evaluator.evaluate_candidates(
            items,
            candidate_workers=max(0, self.config.candidate_workers),
        )
        return [
            self._finalize_candidate(prepared, evaluation)
            for prepared, evaluation in zip(prepared_candidates, evaluations)
        ]

    def _reset_islands_if_needed(self) -> None:
        now = time.time()
        if now - self._last_reset_time <= self.config.reset_period_seconds:
            return
        self._last_reset_time = now
        if not self._islands:
            return
        best_scores = np.array(
            [island.best_cluster_score for island in self._islands], dtype=np.float64
        )
        noise = self._rng.normal(0.0, 1e-6, size=len(self._islands))
        order = np.argsort(best_scores + noise)
        to_reset_count = len(self._islands) // 2
        reset_ids = [int(i) for i in order[:to_reset_count]]
        keep_ids = [int(i) for i in order[to_reset_count:]]
        for island_id in reset_ids:
            founder_candidate: FunSearchCandidate | None = None
            if keep_ids:
                founder_island_id = int(self._rng.choice(keep_ids))
                founder_candidate = self._islands[founder_island_id].best_candidate
            self._islands[island_id] = _Island()
            if founder_candidate is not None:
                self._islands[island_id].register(founder_candidate)
            self._reset_events.append(
                {
                    "timestamp_utc": dt.datetime.now(dt.timezone.utc).isoformat(),
                    "iteration": self._iterations_done,
                    "reset_island_id": island_id,
                    "founder_id": founder_candidate.id if founder_candidate else None,
                }
            )

    def _log_generation(
        self,
        generation: int,
        generated: list[FunSearchCandidate],
        llm_usage: dict[str, int],
        runtime_seconds: float,
    ) -> None:
        total = len(generated)
        syntax = sum(1 for c in generated if c.status not in ("failed_format", "failed_diff", "failed_syntax"))
        functionality = sum(
            1
            for c in generated
            if c.status
            not in ("failed_format", "failed_diff", "failed_syntax", "failed_functionality")
        )
        synthesis = sum(1 for c in generated if c.status == "success")
        success_rates = {
            "syntax": (syntax / total) if total else 0.0,
            "functionality": (functionality / total) if total else 0.0,
            "synthesis_ppa": (synthesis / total) if total else 0.0,
            "total_syntax": (syntax / total) if total else 0.0,
            "total_functionality": (functionality / total) if total else 0.0,
            "total_synthesis_ppa": (synthesis / total) if total else 0.0,
        }
        status_counts: dict[str, int] = {}
        for candidate in generated:
            status_counts[candidate.status] = status_counts.get(candidate.status, 0) + 1

        payload = {
            "generation": generation,
            "backend_name": self.name,
            "problem_name": self.context.problem_name,
            "benchmark_name": self.context.benchmark_name,
            "runtime_seconds": runtime_seconds,
            "llm_api_calls": llm_usage.get("api_calls", 0),
            "llm_usage": [llm_usage],
            "status_counts_this_generation": status_counts,
            "success_rates": success_rates,
            "population_ppa": {
                "best_score": self._best_candidate.score if self._best_candidate else None,
                "best_metrics": self._best_candidate.ppa_metrics if self._best_candidate else {},
            },
        }
        self.services.artifact_writer.append_generation_log(payload)
        self._generation_stats.append(payload)

    def _summary(self, reason: str) -> dict[str, Any]:
        end_utc = dt.datetime.now(dt.timezone.utc)
        runtime = time.time() - self._start_time
        total = max(1, self._evaluations_done)
        syntax_pass = sum(
            c for status, c in self._status_counts.items() if status not in ("failed_format", "failed_diff", "failed_syntax")
        )
        functionality_pass = sum(
            c
            for status, c in self._status_counts.items()
            if status
            not in ("failed_format", "failed_diff", "failed_syntax", "failed_functionality")
        )
        synthesis_pass = self._status_counts.get("success", 0)
        summary = {
            "backend_name": self.name,
            "backend_details": {
                "num_islands": self.config.num_islands,
                "functions_per_prompt": self.config.functions_per_prompt,
                "samples_per_prompt": self.config.samples_per_prompt,
                "reset_events": self._reset_events,
                "score_reducer": self.config.score_reducer,
                "signature_keys": sorted(self._signature_keys_seen),
                "seed": self.config.seed,
                "feedback_policy": self.config.feedback_policy,
                "feedback_sample_probability": self.config.feedback_sample_probability,
                "evaluation_mode": self.services.candidate_evaluator.evaluation_mode
                if self.services.candidate_evaluator
                else "strict_ablation",
                "accelerated_synthesis_top_k": self.services.candidate_evaluator.accelerated_synthesis_top_k
                if self.services.candidate_evaluator
                else None,
                "termination_reason": reason,
                "island_best_scores": [island.best_cluster_score for island in self._islands],
                "cluster_counts_per_island": [len(island.clusters) for island in self._islands],
            },
            "problem_name": self.context.problem_name,
            "benchmark_name": self.context.benchmark_name,
            "model_name": self.context.model_name,
            "strategy_selection_method": "funsearch",
            "generation_mode": self.context.generation_mode,
            "start_time": self._start_utc.isoformat() if self._start_utc else None,
            "end_time": end_utc.isoformat(),
            "total_runtime_seconds": runtime,
            "total_llm_api_calls": self._total_llm_usage["api_calls"],
            "total_llm_prompt_tokens": self._total_llm_usage["prompt_tokens"],
            "total_llm_completion_tokens": self._total_llm_usage["completion_tokens"],
            "total_llm_code_prompt_tokens": self._total_llm_usage["code_prompt_tokens"],
            "total_llm_code_completion_tokens": self._total_llm_usage["code_completion_tokens"],
            "total_llm_feedback_prompt_tokens": self._total_llm_usage["feedback_prompt_tokens"],
            "total_llm_feedback_completion_tokens": self._total_llm_usage["feedback_completion_tokens"],
            "total_generations": self._iterations_done,
            "total_candidates_generated": self._evaluations_done,
            "accumulated_strategy_counts": {},
            "accumulated_strategy_rewards": {},
            "accumulated_success_rates": {
                "format": 1.0
                - (self._status_counts.get("failed_format", 0) / total),
                "diff": 1.0 - (self._status_counts.get("failed_diff", 0) / total),
                "syntax": syntax_pass / total,
                "functionality": functionality_pass / total,
                "synthesis_ppa": synthesis_pass / total,
            },
            "ref_ppa_metric": self.services.candidate_evaluator.ref_ppa_metrics
            if self.services.candidate_evaluator
            else {},
            "final_population_ppa": {
                "best_score": self._best_candidate.score if self._best_candidate else None,
                "best_metrics": self._best_candidate.ppa_metrics if self._best_candidate else {},
                "average_score": None,
                "average_metrics": {},
            },
            "final_population_ppa_details": [
                {
                    "id": self._best_candidate.id,
                    "strategy": "funsearch",
                    "score": self._best_candidate.score,
                    "ppa_metrics": self._best_candidate.ppa_metrics,
                }
            ]
            if self._best_candidate
            else [],
            "generation_statistics": self._generation_stats,
            "run_budget": {
                "max_evaluations": self.config.max_evaluations,
                "max_iterations": self.config.max_iterations,
                "max_runtime_seconds": self.config.max_runtime_seconds,
                "max_llm_calls": self.config.max_llm_calls,
                "max_llm_tokens": self.config.max_llm_tokens,
                "evaluation_mode": self.services.candidate_evaluator.evaluation_mode
                if self.services.candidate_evaluator
                else "strict_ablation",
                "accelerated_synthesis_top_k": self.services.candidate_evaluator.accelerated_synthesis_top_k
                if self.services.candidate_evaluator
                else None,
            },
            "stage_success_rates": {
                "format": 1.0 - (self._status_counts.get("failed_format", 0) / total),
                "syntax": syntax_pass / total,
                "functionality": functionality_pass / total,
                "synthesis": synthesis_pass / total,
            },
            "best_candidate": {
                "id": self._best_candidate.id if self._best_candidate else None,
                "status": self._best_candidate.status if self._best_candidate else None,
                "score": self._best_candidate.score if self._best_candidate else None,
                "code_file_path": self._best_candidate.code_file_path
                if self._best_candidate
                else None,
                "ppa_metrics": self._best_candidate.ppa_metrics if self._best_candidate else {},
            },
            "runtime": {"seconds": runtime},
            "llm_usage": self._total_llm_usage,
        }
        return add_legacy_strategy_key_alias(summary)

    def run(self) -> BackendRunResult:
        self.initialize()
        self._load_prompt("system/whole")
        init_start = time.time()
        initial = asyncio.run(
            self.services.llm.generate_n_responses(
                prompt=self.context.problem_context.problem_description,
                n=self.config.initial_population_size,
                temperature=self.config.default_llm_temp,
                top_p=self.config.default_llm_top_p,
                max_tokens=self.config.default_llm_max_tokens,
                generation_mode="whole",
                system_prompt_override=self._prompt_cache["system/whole"],
            )
        )
        init_candidates: list[FunSearchCandidate] = []
        prepared_initial: list[_PreparedCandidate] = []
        for thought, code, meta in initial:
            is_ok = bool(meta.get("format_ok", False))
            thought_text = thought or ""
            code_text = (code or meta.get("raw", "") or "").strip()
            prepared_initial.append(
                self._prepare_candidate(
                    generation=0,
                    island_id=None,
                    thought=thought_text,
                    code=code_text,
                    initial_status="new" if is_ok else "failed_format",
                    parent_ids=[],
                )
            )
        init_candidates.extend(self._evaluate_and_register_batch(prepared_initial))
        init_usage = self._consume_llm_usage()
        self._log_generation(
            generation=0,
            generated=init_candidates,
            llm_usage=init_usage,
            runtime_seconds=time.time() - init_start,
        )

        termination_reason = "unknown"
        while True:
            exhausted, reason = self._check_budget_exhausted()
            if exhausted:
                termination_reason = reason
                break
            iteration_start = time.time()
            self._iterations_done += 1
            chosen_island = int(self._rng.integers(low=0, high=max(1, len(self._islands))))
            sampled = self._sample_prompt_candidates(chosen_island)
            prompt = self._build_funsearch_prompt(sampled)
            generated = asyncio.run(
                self.services.llm.generate_n_responses(
                    prompt=prompt,
                    n=max(1, self.config.samples_per_prompt),
                    temperature=self.config.default_llm_temp,
                    top_p=self.config.default_llm_top_p,
                    max_tokens=self.config.default_llm_max_tokens,
                    generation_mode="whole",
                    system_prompt_override=self._prompt_cache["system/whole"],
                )
            )
            new_candidates: list[FunSearchCandidate] = []
            parent_ids = [candidate.id for candidate in sampled]
            prepared_candidates: list[_PreparedCandidate] = []
            for thought, code, meta in generated:
                is_ok = bool(meta.get("format_ok", False))
                thought_text = thought or ""
                code_text = (code or meta.get("raw", "") or "").strip()
                prepared_candidates.append(
                    self._prepare_candidate(
                        generation=self._iterations_done,
                        island_id=chosen_island,
                        thought=thought_text,
                        code=code_text,
                        initial_status="new" if is_ok else "failed_format",
                        parent_ids=parent_ids,
                    )
                )
            new_candidates.extend(self._evaluate_and_register_batch(prepared_candidates))
            usage = self._consume_llm_usage()
            self._log_generation(
                generation=self._iterations_done,
                generated=new_candidates,
                llm_usage=usage,
                runtime_seconds=time.time() - iteration_start,
            )
            exhausted, reason = self._check_budget_exhausted()
            if exhausted:
                termination_reason = reason
                break

        summary = self._summary(termination_reason)
        summary_path = self.services.artifact_writer.write_summary(summary)
        self._summary_cache = summary
        if self._best_candidate is not None:
            score = self._best_candidate.score
            if self._best_candidate.status == "success":
                result_str = (
                    f"{self.context.problem_name},success,{self._best_candidate.code_file_path},N/A,{score}"
                )
                return BackendRunResult(
                    backend_name=self.name,
                    problem_name=self.context.problem_name,
                    status="success",
                    result_string=result_str,
                    best_code_path=self._best_candidate.code_file_path,
                    best_report_path=None,
                    best_score=score,
                    summary_path=summary_path,
                )
            result_str = (
                f"{self.context.problem_name},failed,{self._best_candidate.code_file_path},N/A,{score}"
            )
            return BackendRunResult(
                backend_name=self.name,
                problem_name=self.context.problem_name,
                status="failed",
                result_string=result_str,
                best_code_path=self._best_candidate.code_file_path,
                best_report_path=None,
                best_score=score,
                summary_path=summary_path,
            )
        result_str = f"{self.context.problem_name},failed"
        return BackendRunResult(
            backend_name=self.name,
            problem_name=self.context.problem_name,
            status="failed",
            result_string=result_str,
            summary_path=summary_path,
        )

    def get_result_summary(self) -> dict[str, Any]:
        return self._summary_cache or {}

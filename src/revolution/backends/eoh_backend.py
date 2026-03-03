from __future__ import annotations

import asyncio
import datetime as dt
import json
import math
import random
import uuid
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Literal

from revolution.backends.base import (
    BackendExecutionContext,
    BackendRunResult,
    BackendServices,
    EvolutionBackend,
)
from revolution.llm import LLMRequest
from revolution.prompt_store import safe_format
from revolution.runtime import CandidateEvaluation, CandidateEvaluator, CandidateWorkItem
from revolution.runtime.diff_apply import DiffApplyConfig, DiffApplier
from revolution.runtime.run_artifacts import add_legacy_strategy_key_alias


EoHOperator = Literal["i1", "e1", "e2", "m1", "m2", "m3"]
_ALLOWED_OPERATORS = {"i1", "e1", "e2", "m1", "m2", "m3"}


@dataclass(frozen=True)
class EoHBackendConfig:
    """Configuration for the EoH backend."""

    population_size: int = 5
    num_generations: int = 5
    operators: tuple[str, ...] = ("e1", "e2", "m1", "m2", "m3")
    parent_count: int = 2
    selection_method: str = "rank"
    management_method: str = "elitism"
    generation_mode: str = "whole"
    default_llm_temp: float = 1.0
    default_llm_top_p: float = 0.95
    default_llm_max_tokens: int = 2048
    diff_max_tokens: int = 1024
    max_evaluations: int | None = None
    max_llm_calls: int | None = None
    max_runtime_seconds: float | None = None
    max_llm_tokens: int | None = None
    prompt_profile: str = "eoh"
    prompt_root: str | None = None
    strict_prompt_keys: bool = True
    seed: int | None = None
    candidate_workers: int = 0
    diff_apply_policy: str = "hybrid"
    diff_similarity_threshold: float = 0.86
    diff_fuzzy_margin: float = 0.03


@dataclass
class EoHCandidate:
    id: str
    generation: int
    operator: str
    thought: str
    code: str
    code_file_path: str
    status: str
    score: float
    parent_ids: list[str] = field(default_factory=list)
    ppa_metrics: dict[str, float] = field(default_factory=dict)
    feedback: str = ""
    generated_mode: str = "whole"
    diff_apply_diagnostics: dict[str, Any] | None = None


@dataclass
class _PreparedCandidate:
    generation: int
    operator: str
    thought: str
    code: str
    initial_status: str
    parent_ids: list[str]
    generated_mode: str
    code_file_path: str
    diff_payload: str | None = None
    diff_apply_diagnostics: dict[str, Any] | None = None


class EoHBackend(EvolutionBackend):
    """Evolution of Heuristics backend for ablation runs."""

    def __init__(
        self,
        context: BackendExecutionContext,
        services: BackendServices,
        config: EoHBackendConfig,
    ) -> None:
        self.context = context
        self.services = services
        self.config = config
        self._rng = random.Random(config.seed)
        self._population: list[EoHCandidate] = []
        self._best_candidate: EoHCandidate | None = None
        self._generation_stats: list[dict[str, Any]] = []
        self._summary_cache: dict[str, Any] | None = None
        self._start_time = 0.0
        self._start_utc: dt.datetime | None = None
        self._evaluations_done = 0
        self._iterations_done = 0
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
        self._reference_ppa_available = False
        self._diff_applier = DiffApplier(
            DiffApplyConfig(
                policy=self.config.diff_apply_policy,  # type: ignore[arg-type]
                similarity_threshold=self.config.diff_similarity_threshold,
                fuzzy_margin=self.config.diff_fuzzy_margin,
            )
        )

    @property
    def name(self) -> str:
        return "eoh"

    def _load_prompt(self, key: str) -> str:
        value = self.services.prompt_store.read(key)
        if value is None:
            abs_path = self.services.prompt_store._abs_path_for(key)
            raise FileNotFoundError(
                f"Missing required EoH prompt key '{key}' at '{abs_path}'."
            )
        self._prompt_cache[key] = value
        return value

    def _system_prompt(self, mode: Literal["whole", "diff"]) -> str:
        key = f"system/{mode}"
        return self._prompt_cache.get(key) or self._load_prompt(key)

    def _operator_prompt(self, operator: str, mode: Literal["whole", "diff"]) -> str:
        key = f"eoh/{operator}/{mode}"
        return self._prompt_cache.get(key) or self._load_prompt(key)

    def _validate_prompt_profile(self) -> None:
        if not self.config.strict_prompt_keys:
            return
        missing: list[str] = []
        required: list[str] = ["system/whole", "eoh/i1/whole"]
        if self.config.generation_mode == "diff":
            required.append("system/diff")
        for operator in self.config.operators:
            required.append(f"eoh/{operator}/{self.config.generation_mode}")

        for key in required:
            if not self.services.prompt_store.has(key):
                missing.append(f"{key} -> {self.services.prompt_store._abs_path_for(key)}")
        if missing:
            formatted = "\n".join(missing)
            raise FileNotFoundError(
                f"EoH prompt profile validation failed. Missing keys:\n{formatted}"
            )

    def _validate_config(self) -> None:
        if self.config.population_size <= 0:
            raise ValueError("population_size must be > 0")
        if self.config.num_generations < 0:
            raise ValueError("num_generations must be >= 0")
        if self.config.generation_mode not in {"whole", "diff"}:
            raise ValueError("generation_mode must be 'whole' or 'diff'")
        if self.config.selection_method not in {"rank", "random", "tournament"}:
            raise ValueError(
                "selection_method must be one of: rank, random, tournament"
            )
        if self.config.management_method not in {"elitism"}:
            raise ValueError("management_method must be 'elitism'")
        if not self.config.operators:
            raise ValueError("operators must contain at least one entry")
        invalid = [op for op in self.config.operators if op not in _ALLOWED_OPERATORS]
        if invalid:
            raise ValueError(
                "Unsupported EoH operators: "
                + ", ".join(sorted(set(invalid)))
                + ". Allowed: i1, e1, e2, m1, m2, m3."
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
        self._validate_config()
        self._validate_prompt_profile()
        self._start_time = dt.datetime.now(dt.timezone.utc).timestamp()
        self._start_utc = dt.datetime.now(dt.timezone.utc)

        ref_ppa = self._read_reference_ppa_metrics()
        if self.services.candidate_evaluator is None:
            self.services.candidate_evaluator = CandidateEvaluator(
                context=self.context.problem_context,
                problem_description=self.context.problem_context.problem_description,
                verilog_evaluator=self.services.verilog_evaluator,
                synthesis_evaluator=self.services.synthesis_evaluator,
                ref_ppa_metrics=ref_ppa,
            )
        elif (
            not getattr(self.services.candidate_evaluator, "ref_ppa_metrics", {})
            and ref_ppa
        ):
            self.services.candidate_evaluator.ref_ppa_metrics = ref_ppa
        self._reference_ppa_available = bool(
            getattr(self.services.candidate_evaluator, "ref_ppa_metrics", {})
        )

    def _consume_llm_usage(self) -> dict[str, int]:
        usage = asyncio.run(self.services.llm.get_and_reset_usage_stats())
        for key, value in usage.items():
            self._total_llm_usage[key] = self._total_llm_usage.get(key, 0) + int(value)
        return usage

    def _record_status(self, status: str) -> None:
        self._status_counts[status] = self._status_counts.get(status, 0) + 1

    def _check_budget_exhausted(self) -> tuple[bool, str]:
        elapsed = dt.datetime.now(dt.timezone.utc).timestamp() - self._start_time
        total_tokens = (
            self._total_llm_usage["prompt_tokens"]
            + self._total_llm_usage["completion_tokens"]
        )
        if (
            self.config.max_runtime_seconds is not None
            and elapsed >= self.config.max_runtime_seconds
        ):
            return True, "max_runtime_seconds"
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

    def _fitness_from_evaluation(self, evaluation: CandidateEvaluation) -> float:
        try:
            score = float(evaluation.score)
        except (TypeError, ValueError):
            return float("-inf")
        if not math.isfinite(score):
            return float("-inf")
        return score

    def _serialize_parent(self, parent: EoHCandidate) -> dict[str, Any]:
        return {
            "id": parent.id,
            "generation": parent.generation,
            "operator": parent.operator,
            "status": parent.status,
            "score": parent.score,
            "thought": parent.thought,
            "code": parent.code,
            "feedback": parent.feedback,
            "ppa_metrics": parent.ppa_metrics,
            "code_file_path": parent.code_file_path,
        }

    def _build_prompt_context(self, operator: str, parents: list[EoHCandidate]) -> dict[str, Any]:
        context: dict[str, Any] = {
            "task": operator,
            "problem_description": self.context.problem_context.problem_description,
        }
        if not parents:
            context["task"] = "initialize_population"
            return context
        if len(parents) == 1:
            context["parent"] = self._serialize_parent(parents[0])
            return context
        context["parents"] = [self._serialize_parent(parent) for parent in parents]
        return context

    def _build_prompt(
        self,
        *,
        operator: str,
        mode: Literal["whole", "diff"],
        parents: list[EoHCandidate],
    ) -> str:
        template = self._operator_prompt(operator, mode)
        context_obj = self._build_prompt_context(operator, parents)
        if mode == "diff":
            base_parent = parents[0] if parents else None
            return safe_format(
                template,
                context_json=json.dumps(context_obj, indent=2),
                file_to_edit=base_parent.code_file_path if base_parent else "",
                original_file=base_parent.code if base_parent else "",
            )
        return safe_format(template, context_json=json.dumps(context_obj, indent=2))

    def _sorted_population(self) -> list[EoHCandidate]:
        return sorted(
            self._population,
            key=lambda cand: (cand.score, cand.status == "success"),
            reverse=True,
        )

    def _select_one_parent(self) -> EoHCandidate:
        if not self._population:
            raise RuntimeError("cannot sample parent from empty population")
        if self.config.selection_method == "random":
            return self._rng.choice(self._population)
        if self.config.selection_method == "tournament":
            k = min(3, len(self._population))
            sampled = self._rng.sample(self._population, k=k)
            return max(sampled, key=lambda cand: cand.score)

        ranked = self._sorted_population()
        weights = [len(ranked) - idx for idx, _ in enumerate(ranked)]
        return self._rng.choices(ranked, weights=weights, k=1)[0]

    def _sample_parents(self, required: int) -> list[EoHCandidate]:
        if required <= 0:
            return []
        if not self._population:
            return []
        picked: list[EoHCandidate] = []
        seen_ids: set[str] = set()
        max_unique = min(required, len(self._population))
        while len(picked) < max_unique:
            candidate = self._select_one_parent()
            if candidate.id in seen_ids:
                continue
            seen_ids.add(candidate.id)
            picked.append(candidate)
        while len(picked) < required:
            picked.append(picked[0])
        return picked

    def _prepare_candidate(
        self,
        *,
        generation: int,
        operator: str,
        thought: str,
        code: str,
        initial_status: str,
        parent_ids: list[str],
        generated_mode: str,
        diff_payload: str | None = None,
        diff_apply_diagnostics: dict[str, Any] | None = None,
    ) -> _PreparedCandidate:
        label = f"sample{self._evaluations_done + 1}_{uuid.uuid4().hex[:8]}_eoh_{operator}"
        code_path, _ = self.services.artifact_writer.write_candidate(
            generation=generation,
            label=label,
            code=code,
            thought=thought,
            metadata={
                "operator": operator,
                "parent_ids": parent_ids,
                "generated_mode": generated_mode,
                "initial_status": initial_status,
                "diff_apply_diagnostics": diff_apply_diagnostics,
            },
        )
        if initial_status == "failed_diff" and diff_payload is not None:
            self._write_diff_error_file(
                code_file_path=code_path,
                diff_payload=diff_payload,
                diagnostics=diff_apply_diagnostics,
            )
        return _PreparedCandidate(
            generation=generation,
            operator=operator,
            thought=thought,
            code=code,
            initial_status=initial_status,
            parent_ids=parent_ids,
            generated_mode=generated_mode,
            code_file_path=code_path,
            diff_payload=diff_payload,
            diff_apply_diagnostics=diff_apply_diagnostics,
        )

    def _write_diff_error_file(
        self,
        *,
        code_file_path: str,
        diff_payload: str,
        diagnostics: dict[str, Any] | None,
    ) -> None:
        base = str(code_file_path).rsplit(".", 1)[0]
        payload = {
            "timestamp_utc": dt.datetime.now(dt.timezone.utc).isoformat(),
            "diff": diff_payload,
            "diagnostics": diagnostics or {},
            "reason_code": (diagnostics or {}).get("reason_code"),
            "reason": (diagnostics or {}).get("reason"),
        }
        Path(f"{base}_diff_apply_error.json").write_text(
            json.dumps(payload, indent=2),
            encoding="utf-8",
        )

    def _finalize_candidate(
        self,
        prepared: _PreparedCandidate,
        evaluation: CandidateEvaluation,
    ) -> EoHCandidate:
        self._evaluations_done += 1
        self._record_status(evaluation.status)
        fitness = self._fitness_from_evaluation(evaluation)
        feedback = ""
        if evaluation.feedback_payload:
            feedback = str(evaluation.feedback_payload.get("simulation_log", ""))

        candidate = EoHCandidate(
            id=str(uuid.uuid4()),
            generation=prepared.generation,
            operator=prepared.operator,
            thought=prepared.thought,
            code=prepared.code,
            code_file_path=prepared.code_file_path,
            status=evaluation.status,
            score=fitness,
            parent_ids=prepared.parent_ids,
            ppa_metrics=evaluation.ppa_metrics,
            feedback=feedback,
            generated_mode=prepared.generated_mode,
            diff_apply_diagnostics=prepared.diff_apply_diagnostics,
        )

        if self._best_candidate is None or candidate.score > self._best_candidate.score:
            self._best_candidate = candidate
        return candidate

    def _evaluate_and_register_batch(
        self,
        prepared_candidates: list[_PreparedCandidate],
    ) -> list[EoHCandidate]:
        if not prepared_candidates:
            return []
        assert self.services.candidate_evaluator is not None
        items = [
            CandidateWorkItem(
                code=prepared.code,
                code_file_path=prepared.code_file_path,
                initial_status=prepared.initial_status,
            )
            for prepared in prepared_candidates
        ]
        evaluations = self.services.candidate_evaluator.evaluate_candidates(
            items,
            candidate_workers=max(0, self.config.candidate_workers),
        )
        return [
            self._finalize_candidate(prepared, evaluation)
            for prepared, evaluation in zip(prepared_candidates, evaluations)
        ]

    def _update_population(self, candidates: list[EoHCandidate]) -> None:
        if self.config.management_method != "elitism":
            raise ValueError(
                f"Unsupported management_method '{self.config.management_method}'."
            )
        merged = self._population + candidates
        merged.sort(key=lambda cand: (cand.score, cand.status == "success"), reverse=True)
        self._population = merged[: self.config.population_size]
        if self._population:
            top = self._population[0]
            if self._best_candidate is None or top.score > self._best_candidate.score:
                self._best_candidate = top

    def _log_generation(
        self,
        generation: int,
        generated: list[EoHCandidate],
        llm_usage: dict[str, int],
        runtime_seconds: float,
    ) -> None:
        total = len(generated)
        syntax = sum(
            1
            for candidate in generated
            if candidate.status
            not in ("failed_format", "failed_diff", "failed_syntax")
        )
        functionality = sum(
            1
            for candidate in generated
            if candidate.status
            not in (
                "failed_format",
                "failed_diff",
                "failed_syntax",
                "failed_functionality",
            )
        )
        synthesis = sum(1 for candidate in generated if candidate.status == "success")
        success_rates = {
            "syntax": (syntax / total) if total else 0.0,
            "functionality": (functionality / total) if total else 0.0,
            "synthesis_ppa": (synthesis / total) if total else 0.0,
            "total_syntax": (syntax / total) if total else 0.0,
            "total_functionality": (functionality / total) if total else 0.0,
            "total_synthesis_ppa": (synthesis / total) if total else 0.0,
        }

        status_counts: dict[str, int] = {}
        operator_counts: dict[str, int] = {}
        for candidate in generated:
            status_counts[candidate.status] = status_counts.get(candidate.status, 0) + 1
            operator_counts[candidate.operator] = (
                operator_counts.get(candidate.operator, 0) + 1
            )

        payload = {
            "generation": generation,
            "backend_name": self.name,
            "problem_name": self.context.problem_name,
            "benchmark_name": self.context.benchmark_name,
            "runtime_seconds": runtime_seconds,
            "llm_api_calls": llm_usage.get("api_calls", 0),
            "llm_usage": [llm_usage],
            "status_counts_this_generation": status_counts,
            "operator_counts_this_generation": operator_counts,
            "success_rates": success_rates,
            "population_ppa": {
                "best_score": self._best_candidate.score if self._best_candidate else None,
                "best_metrics": self._best_candidate.ppa_metrics
                if self._best_candidate
                else {},
            },
        }
        self.services.artifact_writer.append_generation_log(payload)
        self._generation_stats.append(payload)

    def _summary(self, reason: str) -> dict[str, Any]:
        end_utc = dt.datetime.now(dt.timezone.utc)
        runtime = end_utc.timestamp() - self._start_time
        total = max(1, self._evaluations_done)
        syntax_pass = sum(
            count
            for status, count in self._status_counts.items()
            if status not in ("failed_format", "failed_diff", "failed_syntax")
        )
        functionality_pass = sum(
            count
            for status, count in self._status_counts.items()
            if status
            not in (
                "failed_format",
                "failed_diff",
                "failed_syntax",
                "failed_functionality",
            )
        )
        synthesis_pass = self._status_counts.get("success", 0)

        summary = {
            "backend_name": self.name,
            "backend_details": {
                "population_size": self.config.population_size,
                "num_generations": self.config.num_generations,
                "operators": list(self.config.operators),
                "selection_method": self.config.selection_method,
                "management_method": self.config.management_method,
                "generation_mode": self.config.generation_mode,
                "seed": self.config.seed,
                "evaluation_mode": self.services.candidate_evaluator.evaluation_mode
                if self.services.candidate_evaluator
                else "strict_ablation",
                "accelerated_synthesis_top_k": self.services.candidate_evaluator.accelerated_synthesis_top_k
                if self.services.candidate_evaluator
                else None,
                "reference_ppa_available": self._reference_ppa_available,
                "termination_reason": reason,
            },
            "problem_name": self.context.problem_name,
            "benchmark_name": self.context.benchmark_name,
            "model_name": self.context.model_name,
            "strategy_selection_method": "eoh",
            "generation_mode": self.context.generation_mode,
            "start_time": self._start_utc.isoformat() if self._start_utc else None,
            "end_time": end_utc.isoformat(),
            "total_runtime_seconds": runtime,
            "total_llm_api_calls": self._total_llm_usage["api_calls"],
            "total_llm_prompt_tokens": self._total_llm_usage["prompt_tokens"],
            "total_llm_completion_tokens": self._total_llm_usage["completion_tokens"],
            "total_llm_code_prompt_tokens": self._total_llm_usage["code_prompt_tokens"],
            "total_llm_code_completion_tokens": self._total_llm_usage[
                "code_completion_tokens"
            ],
            "total_llm_feedback_prompt_tokens": self._total_llm_usage[
                "feedback_prompt_tokens"
            ],
            "total_llm_feedback_completion_tokens": self._total_llm_usage[
                "feedback_completion_tokens"
            ],
            "total_generations": self._iterations_done,
            "total_candidates_generated": self._evaluations_done,
            "accumulated_strategy_counts": {},
            "accumulated_strategy_rewards": {},
            "accumulated_success_rates": {
                "format": 1.0 - (self._status_counts.get("failed_format", 0) / total),
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
                "best_metrics": self._best_candidate.ppa_metrics
                if self._best_candidate
                else {},
                "average_score": (
                    sum(candidate.score for candidate in self._population)
                    / len(self._population)
                    if self._population
                    else None
                ),
                "average_metrics": {},
            },
            "final_population_ppa_details": [
                {
                    "id": candidate.id,
                    "strategy": candidate.operator,
                    "score": candidate.score,
                    "ppa_metrics": candidate.ppa_metrics,
                }
                for candidate in self._population
            ],
            "generation_statistics": self._generation_stats,
            "run_budget": {
                "primary_budget_axis": self.context.metadata.get("primary_budget_axis")
                if isinstance(self.context.metadata, dict)
                else None,
                "max_evaluations": self.config.max_evaluations,
                "max_iterations": self.config.num_generations,
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
                "ppa_metrics": self._best_candidate.ppa_metrics
                if self._best_candidate
                else {},
            },
            "runtime": {"seconds": runtime},
            "llm_usage": self._total_llm_usage,
        }
        return add_legacy_strategy_key_alias(summary)

    def _init_population(self) -> list[EoHCandidate]:
        requested = max(1, self.config.population_size * 2)
        if self.config.max_evaluations is not None:
            requested = min(requested, max(1, self.config.max_evaluations))
        prompt = self._build_prompt(operator="i1", mode="whole", parents=[])
        results = asyncio.run(
            self.services.llm.generate_n_responses(
                prompt=prompt,
                n=requested,
                temperature=self.config.default_llm_temp,
                top_p=self.config.default_llm_top_p,
                max_tokens=self.config.default_llm_max_tokens,
                generation_mode="whole",
                system_prompt_override=self._system_prompt("whole"),
            )
        )

        prepared: list[_PreparedCandidate] = []
        for thought, code, meta in results:
            thought_text = (thought or "").strip()
            code_text = (code or meta.get("raw", "") or "").strip()
            is_ok = bool(meta.get("format_ok", False))
            prepared.append(
                self._prepare_candidate(
                    generation=0,
                    operator="i1",
                    thought=thought_text,
                    code=code_text,
                    initial_status="new" if is_ok else "failed_format",
                    parent_ids=[],
                    generated_mode="whole",
                )
            )

        return self._evaluate_and_register_batch(prepared)

    def _required_parent_count(self, operator: str) -> int:
        if operator == "i1":
            return 0
        if operator == "e2":
            return max(2, self.config.parent_count)
        return 1

    def _remaining_eval_budget(self) -> int | None:
        if self.config.max_evaluations is None:
            return None
        return max(0, self.config.max_evaluations - self._evaluations_done)

    def _run_generation(self, generation: int) -> list[EoHCandidate]:
        generated: list[EoHCandidate] = []
        for operator in self.config.operators:
            exhausted, _ = self._check_budget_exhausted()
            if exhausted:
                break

            remaining = self._remaining_eval_budget()
            if remaining is not None and remaining <= 0:
                break

            batch_size = self.config.population_size
            if remaining is not None:
                batch_size = min(batch_size, remaining)
            if batch_size <= 0:
                break

            requests: list[LLMRequest] = []
            metadata: list[tuple[list[EoHCandidate], Literal["whole", "diff"], str]] = []
            for _ in range(batch_size):
                required_parents = self._required_parent_count(operator)
                parents = self._sample_parents(required_parents)
                if required_parents > 0 and len(parents) < required_parents:
                    continue

                if operator == "i1":
                    mode: Literal["whole", "diff"] = "whole"
                else:
                    mode = "diff" if self.config.generation_mode == "diff" else "whole"
                prompt = self._build_prompt(operator=operator, mode=mode, parents=parents)
                requests.append(
                    {
                        "prompt": prompt,
                        "generation_mode": mode,
                        "system_prompt": self._system_prompt(mode),
                        "max_tokens": self.config.diff_max_tokens
                        if mode == "diff"
                        else self.config.default_llm_max_tokens,
                    }
                )
                metadata.append((parents, mode, operator))

            if not requests:
                continue

            llm_results = asyncio.run(
                self.services.llm.generate_batch_responses(
                    requests,
                    self.config.default_llm_temp,
                    self.config.default_llm_top_p,
                    self.config.default_llm_max_tokens,
                )
            )

            prepared: list[_PreparedCandidate] = []
            for index, (thought, code, meta) in enumerate(llm_results):
                parents, mode, op = metadata[index]
                parent_ids = [parent.id for parent in parents]
                thought_text = (thought or "").strip()
                raw_text = (code or meta.get("raw", "") or "").strip()
                is_ok = bool(meta.get("format_ok", False))
                initial_status = "new" if is_ok else "failed_format"
                final_code = raw_text
                diff_payload: str | None = None
                diff_diag: dict[str, Any] | None = None

                if is_ok and mode == "diff":
                    diff_payload = raw_text
                    base_parent = parents[0]
                    applied = self._diff_applier.apply(
                        base_parent.code,
                        diff_payload,
                        target_file_path=base_parent.code_file_path,
                    )
                    if applied is None:
                        initial_status = "failed_diff"
                        final_code = base_parent.code
                        diff_diag = self._diff_applier.last_diff_diagnostics
                    else:
                        final_code = applied

                prepared.append(
                    self._prepare_candidate(
                        generation=generation,
                        operator=op,
                        thought=thought_text,
                        code=final_code,
                        initial_status=initial_status,
                        parent_ids=parent_ids,
                        generated_mode=mode,
                        diff_payload=diff_payload,
                        diff_apply_diagnostics=diff_diag,
                    )
                )

            generated.extend(self._evaluate_and_register_batch(prepared))

        return generated

    def run(self) -> BackendRunResult:
        self.initialize()

        init_start = dt.datetime.now(dt.timezone.utc).timestamp()
        initial_candidates = self._init_population()
        self._update_population(initial_candidates)
        init_usage = self._consume_llm_usage()
        self._log_generation(
            generation=0,
            generated=initial_candidates,
            llm_usage=init_usage,
            runtime_seconds=dt.datetime.now(dt.timezone.utc).timestamp() - init_start,
        )

        termination_reason = "max_generations"
        for generation in range(1, self.config.num_generations + 1):
            exhausted, reason = self._check_budget_exhausted()
            if exhausted:
                termination_reason = reason
                break

            generation_start = dt.datetime.now(dt.timezone.utc).timestamp()
            self._iterations_done = generation
            generated = self._run_generation(generation)
            if generated:
                self._update_population(generated)
            usage = self._consume_llm_usage()
            self._log_generation(
                generation=generation,
                generated=generated,
                llm_usage=usage,
                runtime_seconds=dt.datetime.now(dt.timezone.utc).timestamp()
                - generation_start,
            )

            exhausted, reason = self._check_budget_exhausted()
            if exhausted:
                termination_reason = reason
                break

        summary = self._summary(termination_reason)
        summary_path = self.services.artifact_writer.write_summary(summary)
        self._summary_cache = summary

        if self._best_candidate is None:
            return BackendRunResult(
                backend_name=self.name,
                problem_name=self.context.problem_name,
                status="failed",
                result_string=f"{self.context.problem_name},failed",
                summary_path=summary_path,
            )

        status = "success" if self._best_candidate.status == "success" else "failed"
        result_str = (
            f"{self.context.problem_name},{status},{self._best_candidate.code_file_path},N/A,"
            f"{self._best_candidate.score}"
        )
        return BackendRunResult(
            backend_name=self.name,
            problem_name=self.context.problem_name,
            status=status,
            result_string=result_str,
            best_code_path=self._best_candidate.code_file_path,
            best_report_path=None,
            best_score=self._best_candidate.score,
            summary_path=summary_path,
        )

    def get_result_summary(self) -> dict[str, Any]:
        return self._summary_cache or {}

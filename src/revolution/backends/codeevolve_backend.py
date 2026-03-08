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
from revolution.runtime.problem_context import resolve_top_module_name
from revolution.runtime.run_artifacts import add_legacy_strategy_key_alias


_SUPPORTED_SELECTION_POLICIES = {"roulette", "random"}
_SUPPORTED_MIGRATION_TOPOLOGIES = {
    "directed_ring",
    "ring",
    "complete",
    "inward_star",
    "outward_star",
    "star",
    "empty",
}
_SUPPORTED_SCHEDULERS = {"plateau", "fixed"}


@dataclass(frozen=True)
class CodeEvolveBackendConfig:
    num_islands: int = 3
    num_epochs: int = 50
    init_pop: int = 10
    exploration_rate: float = 0.2
    selection_policy: str = "roulette"
    roulette_by_rank: bool = True
    meta_prompting: bool = True
    num_inspirations: int = 2
    max_chat_depth: int = 3
    migration_topology: str = "ring"
    migration_interval: int = 25
    migration_rate: float = 0.1
    use_scheduler: bool = True
    scheduler_type: str = "plateau"
    scheduler_kwargs: dict[str, Any] = field(default_factory=dict)
    generation_mode: str = "whole"
    default_llm_temp: float = 1.0
    default_llm_top_p: float = 0.95
    default_llm_max_tokens: int = 2048
    diff_max_tokens: int = 1024
    max_evaluations: int | None = None
    max_llm_calls: int | None = None
    max_llm_tokens: int | None = None
    max_runtime_seconds: float | None = None
    prompt_profile: str = "codeevolve"
    prompt_root: str | None = None
    strict_prompt_keys: bool = True
    seed: int | None = None
    candidate_workers: int = 0
    diff_apply_policy: str = "hybrid"
    diff_similarity_threshold: float = 0.86
    diff_fuzzy_margin: float = 0.03


@dataclass
class CodeEvolvePrompt:
    id: str
    text: str
    fitness: float
    created_epoch: int
    parent_id: str | None = None
    thought: str = ""
    usage_count: int = 0


@dataclass
class CodeEvolveProgram:
    id: str
    epoch: int
    island_id: int
    prompt_id: str
    thought: str
    code: str
    code_file_path: str
    status: str
    score: float
    exploration: bool
    ppa_metrics: dict[str, float] = field(default_factory=dict)
    feedback: str = ""
    parent_id: str | None = None
    inspiration_ids: list[str] = field(default_factory=list)
    generated_mode: str = "whole"
    diff_payload: str | None = None
    diff_apply_diagnostics: dict[str, Any] | None = None
    migrated_from: int | None = None
    origin_program_id: str | None = None


@dataclass
class CodeEvolveIsland:
    id: int
    prompts: dict[str, CodeEvolvePrompt] = field(default_factory=dict)
    prompt_order: list[str] = field(default_factory=list)
    programs: dict[str, CodeEvolveProgram] = field(default_factory=dict)
    program_order: list[str] = field(default_factory=list)
    best_prompt_id: str | None = None
    best_program_id: str | None = None

    def prompt_count(self) -> int:
        return len(self.prompt_order)

    def program_count(self) -> int:
        return len(self.program_order)

    def best_program(self) -> CodeEvolveProgram | None:
        if self.best_program_id is None:
            return None
        return self.programs.get(self.best_program_id)

    def best_prompt(self) -> CodeEvolvePrompt | None:
        if self.best_prompt_id is None:
            return None
        return self.prompts.get(self.best_prompt_id)


@dataclass
class CodeEvolveMigrationEvent:
    epoch: int
    source_island: int
    target_island: int
    migrant_program_ids: list[str]
    migrant_count: int


@dataclass
class _PreparedProgram:
    epoch: int
    island_id: int
    prompt_id: str
    thought: str
    code: str
    initial_status: str
    exploration: bool
    parent_id: str | None
    inspiration_ids: list[str]
    generated_mode: str
    code_file_path: str
    diff_payload: str | None = None
    diff_apply_diagnostics: dict[str, Any] | None = None
    migrated_from: int | None = None
    origin_program_id: str | None = None


@dataclass
class _IslandStepResult:
    island_id: int
    epoch: int
    program: CodeEvolveProgram
    meta_prompt_created: bool
    exploration: bool


class CodeEvolveTaskAdapter:
    """Phase-1 adapter that maps RTL benchmark tasks into CodeEvolve state."""

    def __init__(
        self,
        context: BackendExecutionContext,
        candidate_evaluator: CandidateEvaluator | None,
        prompt_store,
    ) -> None:
        self.context = context
        self.candidate_evaluator = candidate_evaluator
        self.prompt_store = prompt_store
        self.top_module_name = resolve_top_module_name(context.problem_context)

    @property
    def problem_description(self) -> str:
        return self.context.problem_context.problem_description

    @property
    def editable_filename(self) -> str:
        return "code.sv"

    @property
    def reference_ppa_available(self) -> bool:
        if self.candidate_evaluator is None:
            return False
        return bool(getattr(self.candidate_evaluator, "ref_ppa_metrics", {}))

    def initial_seed_code(self) -> str:
        return (
            f"module {self.top_module_name};\n"
            "  // Seed implementation used for CodeEvolve phase-1 RTL adaptation.\n"
            "endmodule\n"
        )

    def feedback_text(self, evaluation: CandidateEvaluation) -> str:
        payload = evaluation.feedback_payload or {}
        user_template = self.prompt_store.read("feedback/user") or "{simulation_log}"
        system_template = self.prompt_store.read("feedback/system") or ""
        rendered = safe_format(
            user_template,
            problem_def=payload.get("problem_def", self.problem_description),
            code=payload.get("code", ""),
            simulation_log=payload.get("simulation_log", ""),
        ).strip()
        if system_template:
            return f"{system_template.strip()}\n\n{rendered}".strip()
        return rendered


class CodeEvolveBackend(EvolutionBackend):
    """Native REvolution adaptation of the CodeEvolve search strategy."""

    REQUIRED_PROMPT_KEYS = (
        "system/whole",
        "feedback/system",
        "feedback/user",
        "codeevolve/exploit",
        "codeevolve/explore",
    )

    def __init__(
        self,
        context: BackendExecutionContext,
        services: BackendServices,
        config: CodeEvolveBackendConfig,
    ) -> None:
        self.context = context
        self.services = services
        self.config = config
        self._rng = random.Random(config.seed)
        self._islands: list[CodeEvolveIsland] = []
        self._migration_events: list[CodeEvolveMigrationEvent] = []
        self._generation_stats: list[dict[str, Any]] = []
        self._summary_cache: dict[str, Any] | None = None
        self._start_time = 0.0
        self._start_utc: dt.datetime | None = None
        self._evaluations_done = 0
        self._iterations_done = 0
        self._prompt_cache: dict[str, str] = {}
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
        self._best_program: CodeEvolveProgram | None = None
        self._reference_ppa_available = False
        self._task_adapter: CodeEvolveTaskAdapter | None = None
        self._scheduler_state: dict[int, dict[str, Any]] = {}
        self._adjacency: dict[int, list[int]] = {}
        self._diff_applier = DiffApplier(
            DiffApplyConfig(
                policy=self.config.diff_apply_policy,  # type: ignore[arg-type]
                similarity_threshold=self.config.diff_similarity_threshold,
                fuzzy_margin=self.config.diff_fuzzy_margin,
            )
        )

    @property
    def name(self) -> str:
        return "codeevolve"

    def _load_prompt(self, key: str) -> str:
        value = self.services.prompt_store.read(key)
        if value is None:
            abs_path = self.services.prompt_store._abs_path_for(key)
            raise FileNotFoundError(
                f"Missing required CodeEvolve prompt key '{key}' at '{abs_path}'."
            )
        self._prompt_cache[key] = value
        return value

    def _validate_prompt_profile(self) -> None:
        if not self.config.strict_prompt_keys:
            return
        required = list(self.REQUIRED_PROMPT_KEYS)
        if self.config.generation_mode == "diff":
            required.append("system/diff")
        if self.config.meta_prompting:
            required.append("codeevolve/meta_prompt")
        missing: list[str] = []
        for key in required:
            if not self.services.prompt_store.has(key):
                missing.append(f"{key} -> {self.services.prompt_store._abs_path_for(key)}")
        if missing:
            formatted = "\n".join(missing)
            raise FileNotFoundError(
                f"CodeEvolve prompt profile validation failed. Missing keys:\n{formatted}"
            )

    def _validate_config(self) -> None:
        if self.config.num_islands <= 0:
            raise ValueError("num_islands must be > 0")
        if self.config.num_epochs < 0:
            raise ValueError("num_epochs must be >= 0")
        if self.config.init_pop <= 0:
            raise ValueError("init_pop must be > 0")
        if self.config.selection_policy not in _SUPPORTED_SELECTION_POLICIES:
            raise ValueError(
                "selection_policy must be one of: random, roulette"
            )
        if self.config.migration_topology not in _SUPPORTED_MIGRATION_TOPOLOGIES:
            raise ValueError(
                "Unsupported migration_topology. "
                f"Allowed: {', '.join(sorted(_SUPPORTED_MIGRATION_TOPOLOGIES))}."
            )
        if self.config.scheduler_type not in _SUPPORTED_SCHEDULERS:
            raise ValueError(
                "scheduler_type must be one of: fixed, plateau"
            )
        if self.config.generation_mode not in {"whole", "diff"}:
            raise ValueError("generation_mode must be 'whole' or 'diff'")

    def initialize(self) -> None:
        self._validate_config()
        self._validate_prompt_profile()
        self._start_time = dt.datetime.now(dt.timezone.utc).timestamp()
        self._start_utc = dt.datetime.now(dt.timezone.utc)
        self._islands = [CodeEvolveIsland(id=index) for index in range(self.config.num_islands)]
        self._adjacency = self._build_adjacency()
        if self.services.candidate_evaluator is None:
            raise ValueError("CodeEvolveBackend requires a candidate_evaluator service.")
        self._task_adapter = CodeEvolveTaskAdapter(
            self.context,
            self.services.candidate_evaluator,
            self.services.prompt_store,
        )
        self._reference_ppa_available = self._task_adapter.reference_ppa_available
        for island in self._islands:
            prompt = CodeEvolvePrompt(
                id=f"prompt-{island.id}-seed",
                text=self._load_prompt("codeevolve/explore"),
                fitness=0.0,
                created_epoch=0,
                thought="Seed CodeEvolve exploration prompt.",
            )
            island.prompts[prompt.id] = prompt
            island.prompt_order.append(prompt.id)
            island.best_prompt_id = prompt.id
            self._scheduler_state[island.id] = {
                "current_rate": self.config.exploration_rate,
                "best_fitness": float("-inf"),
                "plateau_steps": 0,
            }

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

    def _build_adjacency(self) -> dict[int, list[int]]:
        count = self.config.num_islands
        adjacency: dict[int, list[int]] = {index: [] for index in range(count)}
        if count <= 1 or self.config.migration_topology == "empty":
            return adjacency
        if self.config.migration_topology == "directed_ring":
            for index in range(count):
                adjacency[index].append((index + 1) % count)
            return adjacency
        if self.config.migration_topology == "ring":
            for index in range(count):
                adjacency[index].append((index + 1) % count)
                adjacency[index].append((index - 1) % count)
            return adjacency
        if self.config.migration_topology == "complete":
            for index in range(count):
                adjacency[index] = [target for target in range(count) if target != index]
            return adjacency
        if self.config.migration_topology == "inward_star":
            for index in range(1, count):
                adjacency[index].append(0)
            return adjacency
        if self.config.migration_topology == "outward_star":
            adjacency[0] = [target for target in range(1, count)]
            return adjacency
        if self.config.migration_topology == "star":
            adjacency[0] = [target for target in range(1, count)]
            for index in range(1, count):
                adjacency[index].append(0)
            return adjacency
        return adjacency

    def _select_prompt(self, island: CodeEvolveIsland, exploration: bool) -> CodeEvolvePrompt:
        prompts = [island.prompts[prompt_id] for prompt_id in island.prompt_order]
        if not prompts:
            raise RuntimeError("CodeEvolve island prompt population is empty.")
        if exploration or self.config.selection_policy == "random":
            prompt = self._rng.choice(prompts)
            prompt.usage_count += 1
            return prompt
        prompt = max(prompts, key=lambda item: (item.fitness, -item.created_epoch))
        prompt.usage_count += 1
        return prompt

    def _ranked_programs(self, island: CodeEvolveIsland) -> list[CodeEvolveProgram]:
        return sorted(
            [island.programs[program_id] for program_id in island.program_order],
            key=lambda item: (item.score, item.epoch),
            reverse=True,
        )

    def _select_program(self, island: CodeEvolveIsland, exploration: bool) -> CodeEvolveProgram | None:
        if not island.program_order:
            return None
        programs = [island.programs[program_id] for program_id in island.program_order]
        if exploration or self.config.selection_policy == "random":
            return self._rng.choice(programs)
        ranked = self._ranked_programs(island)
        if not self.config.roulette_by_rank or len(ranked) == 1:
            return ranked[0]
        weights = [1.0 / float(index + 1) for index in range(len(ranked))]
        return self._rng.choices(ranked, weights=weights, k=1)[0]

    def _sample_inspirations(
        self,
        island: CodeEvolveIsland,
        *,
        parent_id: str | None,
        exploration: bool,
    ) -> list[CodeEvolveProgram]:
        candidates = [
            island.programs[program_id]
            for program_id in island.program_order
            if program_id != parent_id
        ]
        if not candidates or self.config.num_inspirations <= 0:
            return []
        if exploration:
            self._rng.shuffle(candidates)
            return candidates[: self.config.num_inspirations]
        ranked = sorted(candidates, key=lambda item: (item.score, item.epoch), reverse=True)
        return ranked[: self.config.num_inspirations]

    def _ancestors(
        self, island: CodeEvolveIsland, program: CodeEvolveProgram | None
    ) -> list[CodeEvolveProgram]:
        if program is None or self.config.max_chat_depth <= 0:
            return []
        out: list[CodeEvolveProgram] = []
        current = program
        depth = 0
        while current.parent_id and depth < self.config.max_chat_depth:
            parent = island.programs.get(current.parent_id)
            if parent is None:
                break
            out.append(parent)
            current = parent
            depth += 1
        return out

    def _serialize_program(self, island: CodeEvolveIsland, program: CodeEvolveProgram) -> dict[str, Any]:
        return {
            "id": program.id,
            "epoch": program.epoch,
            "island_id": program.island_id,
            "status": program.status,
            "score": program.score,
            "thought": program.thought,
            "code": program.code,
            "feedback": program.feedback,
            "generated_mode": program.generated_mode,
            "inspirations": list(program.inspiration_ids),
            "ancestors": [
                {
                    "id": ancestor.id,
                    "epoch": ancestor.epoch,
                    "thought": ancestor.thought,
                    "score": ancestor.score,
                    "code": ancestor.code,
                    "feedback": ancestor.feedback,
                }
                for ancestor in self._ancestors(island, program)
            ],
        }

    def _build_solution_prompt(
        self,
        island: CodeEvolveIsland,
        *,
        epoch: int,
        active_prompt: CodeEvolvePrompt,
        parent: CodeEvolveProgram | None,
        inspirations: list[CodeEvolveProgram],
        exploration: bool,
        mode: Literal["whole", "diff"],
    ) -> str:
        assert self._task_adapter is not None
        key = "codeevolve/explore" if exploration or parent is None else "codeevolve/exploit"
        template = self._prompt_cache.get(key) or self._load_prompt(key)
        context_obj: dict[str, Any] = {
            "epoch": epoch,
            "task": "initialize_population" if parent is None else (
                "exploration" if exploration else "exploitation"
            ),
            "problem_description": self._task_adapter.problem_description,
            "editable_filename": self._task_adapter.editable_filename,
            "active_prompt": {
                "id": active_prompt.id,
                "fitness": active_prompt.fitness,
                "text": active_prompt.text,
            },
            "seed_code": self._task_adapter.initial_seed_code(),
            "reference_ppa_available": self._task_adapter.reference_ppa_available,
        }
        file_to_edit = self._task_adapter.editable_filename
        original_file = self._task_adapter.initial_seed_code()
        if parent is not None:
            context_obj["parent"] = self._serialize_program(island, parent)
            file_to_edit = parent.code_file_path
            original_file = parent.code
        if inspirations:
            context_obj["inspirations"] = [
                self._serialize_program(island, inspiration) for inspiration in inspirations
            ]
        rendered = safe_format(
            template,
            context_json=json.dumps(context_obj, indent=2),
            file_to_edit=file_to_edit,
            original_file=original_file,
        )
        return rendered

    def _build_meta_prompt(
        self,
        island: CodeEvolveIsland,
        *,
        epoch: int,
        prompt: CodeEvolvePrompt,
        parent: CodeEvolveProgram | None,
    ) -> str:
        assert self._task_adapter is not None
        template = self._prompt_cache.get("codeevolve/meta_prompt") or self._load_prompt(
            "codeevolve/meta_prompt"
        )
        context_obj = {
            "epoch": epoch,
            "problem_description": self._task_adapter.problem_description,
            "current_prompt": {
                "id": prompt.id,
                "fitness": prompt.fitness,
                "text": prompt.text,
            },
            "parent_solution": self._serialize_program(island, parent) if parent else None,
        }
        return safe_format(template, context_json=json.dumps(context_obj, indent=2))

    def _system_prompt(self, mode: Literal["whole", "diff"]) -> str:
        key = f"system/{mode}"
        return self._prompt_cache.get(key) or self._load_prompt(key)

    def _apply_scheduler(self, island: CodeEvolveIsland) -> float:
        state = self._scheduler_state[island.id]
        if not self.config.use_scheduler or self.config.scheduler_type == "fixed":
            return float(self.config.exploration_rate)
        best = island.best_program()
        best_score = best.score if best is not None else float("-inf")
        plateau_threshold = int(self.config.scheduler_kwargs.get("plateau_threshold", 5))
        min_rate = float(self.config.scheduler_kwargs.get("min_rate", self.config.exploration_rate))
        max_rate = float(self.config.scheduler_kwargs.get("max_rate", max(self.config.exploration_rate, 0.5)))
        increase_factor = float(self.config.scheduler_kwargs.get("increase_factor", 1.05))
        decrease_factor = float(self.config.scheduler_kwargs.get("decrease_factor", 0.95))
        current_rate = float(state.get("current_rate", self.config.exploration_rate))
        previous_best = float(state.get("best_fitness", float("-inf")))
        if best_score > previous_best:
            state["best_fitness"] = best_score
            state["plateau_steps"] = 0
            current_rate = max(min_rate, current_rate * decrease_factor)
        else:
            state["plateau_steps"] = int(state.get("plateau_steps", 0)) + 1
            if int(state["plateau_steps"]) >= plateau_threshold:
                current_rate = min(max_rate, current_rate * increase_factor)
        state["current_rate"] = current_rate
        return current_rate

    def _prepare_program(
        self,
        *,
        epoch: int,
        island_id: int,
        prompt_id: str,
        thought: str,
        code: str,
        initial_status: str,
        exploration: bool,
        parent_id: str | None,
        inspiration_ids: list[str],
        generated_mode: str,
        label: str,
        diff_payload: str | None = None,
        diff_apply_diagnostics: dict[str, Any] | None = None,
        migrated_from: int | None = None,
        origin_program_id: str | None = None,
    ) -> _PreparedProgram:
        metadata = {
            "backend_name": self.name,
            "epoch": epoch,
            "island_id": island_id,
            "exploration": exploration,
            "parent_id": parent_id,
            "inspiration_ids": inspiration_ids,
            "generated_mode": generated_mode,
            "initial_status": initial_status,
            "migrated_from": migrated_from,
            "origin_program_id": origin_program_id,
        }
        code_path, _ = self.services.artifact_writer.write_candidate(
            generation=epoch,
            label=label,
            code=code,
            thought=thought,
            metadata=metadata,
        )
        return _PreparedProgram(
            epoch=epoch,
            island_id=island_id,
            prompt_id=prompt_id,
            thought=thought,
            code=code,
            initial_status=initial_status,
            exploration=exploration,
            parent_id=parent_id,
            inspiration_ids=inspiration_ids,
            generated_mode=generated_mode,
            code_file_path=code_path,
            diff_payload=diff_payload,
            diff_apply_diagnostics=diff_apply_diagnostics,
            migrated_from=migrated_from,
            origin_program_id=origin_program_id,
        )

    def _store_extra_candidate_files(self, prepared: _PreparedProgram, evaluation: CandidateEvaluation) -> None:
        candidate_dir = Path(prepared.code_file_path).parent
        if prepared.diff_payload:
            (candidate_dir / "codeevolve_diff.json").write_text(
                prepared.diff_payload,
                encoding="utf-8",
            )
        if prepared.diff_apply_diagnostics:
            (candidate_dir / "diff_apply_diagnostics.json").write_text(
                json.dumps(prepared.diff_apply_diagnostics, indent=2),
                encoding="utf-8",
            )
        if evaluation.feedback_payload:
            (candidate_dir / "code_feedback.txt").write_text(
                self._task_adapter.feedback_text(evaluation) if self._task_adapter else "",
                encoding="utf-8",
            )

    def _evaluate_prepared_programs(
        self,
        island: CodeEvolveIsland,
        prepared: list[_PreparedProgram],
    ) -> list[CodeEvolveProgram]:
        items = [
            CandidateWorkItem(
                code=item.code,
                code_file_path=item.code_file_path,
                initial_status=item.initial_status,
            )
            for item in prepared
        ]
        evaluations = self.services.candidate_evaluator.evaluate_candidates(
            items,
            candidate_workers=self.config.candidate_workers,
        )
        out: list[CodeEvolveProgram] = []
        for prep, evaluation in zip(prepared, evaluations):
            self._evaluations_done += 1
            self._record_status(evaluation.status)
            feedback = self._task_adapter.feedback_text(evaluation) if self._task_adapter else ""
            program = CodeEvolveProgram(
                id=f"prog-{uuid.uuid4().hex[:12]}",
                epoch=prep.epoch,
                island_id=prep.island_id,
                prompt_id=prep.prompt_id,
                thought=prep.thought,
                code=prep.code,
                code_file_path=prep.code_file_path,
                status=evaluation.status,
                score=float(evaluation.score),
                exploration=prep.exploration,
                ppa_metrics=dict(evaluation.ppa_metrics),
                feedback=feedback,
                parent_id=prep.parent_id,
                inspiration_ids=list(prep.inspiration_ids),
                generated_mode=prep.generated_mode,
                diff_payload=prep.diff_payload,
                diff_apply_diagnostics=prep.diff_apply_diagnostics,
                migrated_from=prep.migrated_from,
                origin_program_id=prep.origin_program_id,
            )
            self._store_extra_candidate_files(prep, evaluation)
            island.programs[program.id] = program
            island.program_order.append(program.id)
            if island.best_program_id is None:
                island.best_program_id = program.id
            else:
                current_best = island.programs[island.best_program_id]
                if (program.score, -program.epoch) > (current_best.score, -current_best.epoch):
                    island.best_program_id = program.id
            prompt = island.prompts.get(program.prompt_id)
            if prompt is not None and math.isfinite(program.score):
                prompt.fitness = max(prompt.fitness, program.score)
                if island.best_prompt_id is None:
                    island.best_prompt_id = prompt.id
                else:
                    best_prompt = island.prompts[island.best_prompt_id]
                    if (prompt.fitness, -prompt.created_epoch) > (
                        best_prompt.fitness,
                        -best_prompt.created_epoch,
                    ):
                        island.best_prompt_id = prompt.id
            if self._best_program is None or (program.score, -program.epoch) > (
                self._best_program.score,
                -self._best_program.epoch,
            ):
                self._best_program = program
            out.append(program)
        return out

    def _register_existing_program(
        self,
        island: CodeEvolveIsland,
        program: CodeEvolveProgram,
    ) -> CodeEvolveProgram:
        island.programs[program.id] = program
        island.program_order.append(program.id)
        if island.best_program_id is None:
            island.best_program_id = program.id
        else:
            current_best = island.programs[island.best_program_id]
            if (program.score, -program.epoch) > (current_best.score, -current_best.epoch):
                island.best_program_id = program.id
        prompt = island.prompts.get(program.prompt_id)
        if prompt is not None and math.isfinite(program.score):
            prompt.fitness = max(prompt.fitness, program.score)
            if island.best_prompt_id is None:
                island.best_prompt_id = prompt.id
            else:
                best_prompt = island.prompts[island.best_prompt_id]
                if (prompt.fitness, -prompt.created_epoch) > (
                    best_prompt.fitness,
                    -best_prompt.created_epoch,
                ):
                    island.best_prompt_id = prompt.id
        if self._best_program is None or (program.score, -program.epoch) > (
            self._best_program.score,
            -self._best_program.epoch,
        ):
            self._best_program = program
        return program

    def _step_island(self, island: CodeEvolveIsland, epoch: int) -> _IslandStepResult | None:
        exhausted, _ = self._check_budget_exhausted()
        if exhausted:
            return None
        if self.config.max_evaluations is not None and self._evaluations_done >= self.config.max_evaluations:
            return None
        is_initializing = island.program_count() < self.config.init_pop
        exploration_rate = self._apply_scheduler(island)
        exploration = False if is_initializing else self._rng.random() <= exploration_rate
        prompt = self._select_prompt(island, exploration=exploration or is_initializing)
        parent = None if is_initializing else self._select_program(island, exploration=exploration)
        inspirations = [] if is_initializing else self._sample_inspirations(
            island,
            parent_id=parent.id if parent else None,
            exploration=exploration,
        )

        meta_prompt_created = False
        active_prompt = prompt
        if (
            self.config.meta_prompting
            and not is_initializing
            and exploration
            and self.services.prompt_store.has("codeevolve/meta_prompt")
        ):
            meta_prompt = self._build_meta_prompt(
                island,
                epoch=epoch,
                prompt=prompt,
                parent=parent,
            )
            thought, code, meta = asyncio.run(
                self.services.llm.generate_response(
                    meta_prompt,
                    temperature=self.config.default_llm_temp,
                    top_p=self.config.default_llm_top_p,
                    max_tokens=self.config.default_llm_max_tokens,
                    generation_mode="whole",
                    system_prompt_override=self._system_prompt("whole"),
                )
            )
            if bool(meta.get("format_ok", False)) and code:
                child_prompt = CodeEvolvePrompt(
                    id=f"prompt-{uuid.uuid4().hex[:12]}",
                    text=code.strip(),
                    fitness=prompt.fitness,
                    created_epoch=epoch,
                    parent_id=prompt.id,
                    thought=(thought or "").strip(),
                )
                island.prompts[child_prompt.id] = child_prompt
                island.prompt_order.append(child_prompt.id)
                active_prompt = child_prompt
                meta_prompt_created = True

        mode: Literal["whole", "diff"] = "whole"
        if not is_initializing and self.config.generation_mode == "diff" and parent is not None:
            mode = "diff"
        solution_prompt = self._build_solution_prompt(
            island,
            epoch=epoch,
            active_prompt=active_prompt,
            parent=parent,
            inspirations=inspirations,
            exploration=exploration or is_initializing,
            mode=mode,
        )
        thought, code, meta = asyncio.run(
            self.services.llm.generate_response(
                solution_prompt,
                temperature=self.config.default_llm_temp,
                top_p=self.config.default_llm_top_p,
                max_tokens=self.config.diff_max_tokens if mode == "diff" else self.config.default_llm_max_tokens,
                generation_mode=mode,
                system_prompt_override=self._system_prompt(mode),
            )
        )
        raw_text = (code or meta.get("raw", "") or "").strip()
        initial_status = "new" if bool(meta.get("format_ok", False)) else "failed_format"
        final_code = raw_text
        diff_payload: str | None = None
        diff_diag: dict[str, Any] | None = None
        if initial_status == "new" and mode == "diff" and parent is not None:
            diff_payload = raw_text
            applied = self._diff_applier.apply(
                parent.code,
                diff_payload,
                target_file_path=parent.code_file_path,
            )
            if applied is None:
                initial_status = "failed_diff"
                final_code = parent.code
                diff_diag = self._diff_applier.last_diff_diagnostics
            else:
                final_code = applied
        label = f"{self.context.problem_name}_epoch{epoch}_island{island.id}"
        prepared = self._prepare_program(
            epoch=epoch,
            island_id=island.id,
            prompt_id=active_prompt.id,
            thought=(thought or "").strip(),
            code=final_code,
            initial_status=initial_status,
            exploration=exploration or is_initializing,
            parent_id=parent.id if parent else None,
            inspiration_ids=[program.id for program in inspirations],
            generated_mode=mode,
            label=label,
            diff_payload=diff_payload,
            diff_apply_diagnostics=diff_diag,
        )
        evaluated = self._evaluate_prepared_programs(island, [prepared])
        if not evaluated:
            return None
        return _IslandStepResult(
            island_id=island.id,
            epoch=epoch,
            program=evaluated[0],
            meta_prompt_created=meta_prompt_created,
            exploration=exploration or is_initializing,
        )

    def _migrate_epoch(self, epoch: int) -> list[CodeEvolveMigrationEvent]:
        if self.config.migration_interval <= 0 or epoch % self.config.migration_interval != 0:
            return []
        events: list[CodeEvolveMigrationEvent] = []
        outgoing: dict[int, list[CodeEvolveProgram]] = {}
        for island in self._islands:
            ranked = self._ranked_programs(island)
            if not ranked:
                continue
            best_id = island.best_program_id
            candidates = [program for program in ranked if program.id != best_id]
            if not candidates:
                candidates = ranked[:1]
            migrant_count = max(1, int(math.ceil(len(candidates) * self.config.migration_rate)))
            outgoing[island.id] = candidates[:migrant_count]
        for source_id, migrants in outgoing.items():
            for target_id in self._adjacency.get(source_id, []):
                target = self._islands[target_id]
                cloned_ids: list[str] = []
                for migrant in migrants:
                    prompt = target.best_prompt()
                    if prompt is None:
                        prompt = next(iter(target.prompts.values()))
                    code_path, _ = self.services.artifact_writer.write_candidate(
                        generation=epoch,
                        label=(
                            f"{self.context.problem_name}_epoch{epoch}_migrant_"
                            f"{source_id}_to_{target_id}_{migrant.id}"
                        ),
                        code=migrant.code,
                        thought=migrant.thought,
                        metadata={
                            "backend_name": self.name,
                            "epoch": epoch,
                            "island_id": target.id,
                            "exploration": False,
                            "parent_id": None,
                            "generated_mode": migrant.generated_mode,
                            "migrated_from": source_id,
                            "origin_program_id": migrant.id,
                            "migration_copy": True,
                        },
                    )
                    clone = CodeEvolveProgram(
                        id=f"prog-{uuid.uuid4().hex[:12]}",
                        epoch=epoch,
                        island_id=target.id,
                        prompt_id=prompt.id,
                        thought=migrant.thought,
                        code=migrant.code,
                        code_file_path=code_path,
                        status=migrant.status,
                        score=migrant.score,
                        exploration=False,
                        ppa_metrics=dict(migrant.ppa_metrics),
                        feedback=migrant.feedback,
                        parent_id=None,
                        inspiration_ids=[],
                        generated_mode=migrant.generated_mode,
                        diff_payload=migrant.diff_payload,
                        diff_apply_diagnostics=migrant.diff_apply_diagnostics,
                        migrated_from=source_id,
                        origin_program_id=migrant.id,
                    )
                    self._register_existing_program(target, clone)
                    cloned_ids.append(clone.id)
                if cloned_ids:
                    event = CodeEvolveMigrationEvent(
                        epoch=epoch,
                        source_island=source_id,
                        target_island=target_id,
                        migrant_program_ids=cloned_ids,
                        migrant_count=len(cloned_ids),
                    )
                    self._migration_events.append(event)
                    events.append(event)
        return events

    def _log_generation(
        self,
        *,
        epoch: int,
        steps: list[_IslandStepResult],
        migration_events: list[CodeEvolveMigrationEvent],
        llm_usage: dict[str, int],
        runtime_seconds: float,
    ) -> None:
        total = len(steps)
        syntax = sum(
            1
            for step in steps
            if step.program.status not in ("failed_format", "failed_diff", "failed_syntax")
        )
        functionality = sum(
            1
            for step in steps
            if step.program.status
            not in ("failed_format", "failed_diff", "failed_syntax", "failed_functionality")
        )
        synthesis = sum(1 for step in steps if step.program.status == "success")
        payload = {
            "generation": epoch,
            "backend_name": self.name,
            "problem_name": self.context.problem_name,
            "benchmark_name": self.context.benchmark_name,
            "runtime_seconds": runtime_seconds,
            "llm_api_calls": llm_usage.get("api_calls", 0),
            "llm_usage": [llm_usage],
            "status_counts_this_generation": self._status_count_payload(
                [step.program for step in steps]
            ),
            "success_rates": {
                "syntax": (syntax / total) if total else 0.0,
                "functionality": (functionality / total) if total else 0.0,
                "synthesis_ppa": (synthesis / total) if total else 0.0,
            },
            "epoch_statistics": {
                "exploration_steps": sum(1 for step in steps if step.exploration),
                "exploitation_steps": sum(1 for step in steps if not step.exploration),
                "meta_prompt_successes": sum(1 for step in steps if step.meta_prompt_created),
                "meta_prompt_failures": sum(
                    1 for step in steps if step.exploration and not step.meta_prompt_created
                ),
                "migrations_sent": sum(event.migrant_count for event in migration_events),
                "migrations_received": sum(event.migrant_count for event in migration_events),
                "best_fitness": self._best_program.score if self._best_program else None,
                "average_live_fitness": (
                    sum(step.program.score for step in steps) / total if total else None
                ),
            },
            "population_ppa": {
                "best_score": self._best_program.score if self._best_program else None,
                "best_metrics": self._best_program.ppa_metrics if self._best_program else {},
            },
        }
        self.services.artifact_writer.append_generation_log(payload)
        self._generation_stats.append(payload)

    def _status_count_payload(self, programs: list[CodeEvolveProgram]) -> dict[str, int]:
        counts: dict[str, int] = {}
        for program in programs:
            counts[program.status] = counts.get(program.status, 0) + 1
        return counts

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
            not in ("failed_format", "failed_diff", "failed_syntax", "failed_functionality")
        )
        synthesis_pass = self._status_counts.get("success", 0)
        fidelity_deviations = [
            "No direct use of vendored CodeEvolve CLI/process orchestration.",
            "Islands execute in-process inside the REvolution backend.",
            "Checkpoint/resume is deferred in phase-1.",
            "MAP-Elites and embeddings are deferred in phase-1.",
            "Problem packaging is adapted to REvolution RTL benchmarks instead of upstream Python problem folders.",
            "Diff application uses the existing REvolution single-file JSON diff format.",
            "Multi-file codebase tasks are deferred.",
        ]
        summary = {
            "backend_name": self.name,
            "backend_details": {
                "num_islands": self.config.num_islands,
                "num_epochs": self.config.num_epochs,
                "init_pop": self.config.init_pop,
                "selection_policy": self.config.selection_policy,
                "roulette_by_rank": self.config.roulette_by_rank,
                "meta_prompting": self.config.meta_prompting,
                "num_inspirations": self.config.num_inspirations,
                "max_chat_depth": self.config.max_chat_depth,
                "migration_topology": self.config.migration_topology,
                "migration_interval": self.config.migration_interval,
                "migration_rate": self.config.migration_rate,
                "scheduler": {
                    "enabled": self.config.use_scheduler,
                    "type": self.config.scheduler_type,
                    "kwargs": self.config.scheduler_kwargs,
                },
                "reference_ppa_available": self._reference_ppa_available,
                "termination_reason": reason,
                "fidelity_deviations": fidelity_deviations,
            },
            "problem_name": self.context.problem_name,
            "benchmark_name": self.context.benchmark_name,
            "model_name": self.context.model_name,
            "strategy_selection_method": "codeevolve",
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
                "best_score": self._best_program.score if self._best_program else None,
                "best_metrics": self._best_program.ppa_metrics if self._best_program else {},
                "average_score": self._average_population_score(),
                "average_metrics": {},
            },
            "final_population_ppa_details": self._population_ppa_details(),
            "generation_statistics": self._generation_stats,
            "run_budget": {
                "primary_budget_axis": self.context.metadata.get("primary_budget_axis")
                if isinstance(self.context.metadata, dict)
                else None,
                "max_evaluations": self.config.max_evaluations,
                "max_iterations": self.config.num_epochs,
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
                "id": self._best_program.id if self._best_program else None,
                "status": self._best_program.status if self._best_program else None,
                "score": self._best_program.score if self._best_program else None,
                "code_file_path": self._best_program.code_file_path if self._best_program else None,
                "ppa_metrics": self._best_program.ppa_metrics if self._best_program else {},
            },
            "runtime": {"seconds": runtime},
            "llm_usage": self._total_llm_usage,
        }
        return add_legacy_strategy_key_alias(summary)

    def _average_population_score(self) -> float | None:
        all_programs = [
            island.programs[program_id]
            for island in self._islands
            for program_id in island.program_order
        ]
        if not all_programs:
            return None
        return sum(program.score for program in all_programs) / len(all_programs)

    def _population_ppa_details(self) -> list[dict[str, Any]]:
        details: list[dict[str, Any]] = []
        for island in self._islands:
            best = island.best_program()
            if best is None:
                continue
            details.append(
                {
                    "id": best.id,
                    "strategy": "exploration" if best.exploration else "exploitation",
                    "score": best.score,
                    "ppa_metrics": best.ppa_metrics,
                    "island_id": island.id,
                }
            )
        return details

    def run(self) -> BackendRunResult:
        self.initialize()
        termination_reason = "max_epochs"
        for epoch in range(1, self.config.num_epochs + 1):
            exhausted, reason = self._check_budget_exhausted()
            if exhausted:
                termination_reason = reason
                break
            epoch_start = dt.datetime.now(dt.timezone.utc).timestamp()
            self._iterations_done = epoch
            step_results: list[_IslandStepResult] = []
            for island in self._islands:
                result = self._step_island(island, epoch)
                if result is not None:
                    step_results.append(result)
                exhausted, reason = self._check_budget_exhausted()
                if exhausted:
                    termination_reason = reason
                    break
            migration_events = self._migrate_epoch(epoch)
            usage = self._consume_llm_usage()
            self._log_generation(
                epoch=epoch,
                steps=step_results,
                migration_events=migration_events,
                llm_usage=usage,
                runtime_seconds=dt.datetime.now(dt.timezone.utc).timestamp() - epoch_start,
            )
            exhausted, reason = self._check_budget_exhausted()
            if exhausted:
                termination_reason = reason
                break

        summary = self._summary(termination_reason)
        summary_path = self.services.artifact_writer.write_summary(summary)
        self._summary_cache = summary

        if self._best_program is None:
            return BackendRunResult(
                backend_name=self.name,
                problem_name=self.context.problem_name,
                status="failed",
                result_string=f"{self.context.problem_name},failed",
                summary_path=summary_path,
            )

        status = "success" if self._best_program.status == "success" else "failed"
        result_str = (
            f"{self.context.problem_name},{status},{self._best_program.code_file_path},N/A,"
            f"{self._best_program.score}"
        )
        return BackendRunResult(
            backend_name=self.name,
            problem_name=self.context.problem_name,
            status=status,
            result_string=result_str,
            best_code_path=self._best_program.code_file_path,
            best_report_path=None,
            best_score=self._best_program.score,
            summary_path=summary_path,
        )

    def get_result_summary(self) -> dict[str, Any]:
        return self._summary_cache or {}

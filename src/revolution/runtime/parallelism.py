from __future__ import annotations

import argparse
import contextlib
import multiprocessing
from dataclasses import dataclass
from typing import Any, Iterator, Sequence


BACKEND_LEGACY_CLI_OPTIONS = {
    "--num_workers": "--total_worker_slots",
    "--candidate_workers": "--max_workers_per_problem",
    "--parallelism_mode": "elastic scheduling is always enabled",
}
EVOLUTION_LEGACY_CLI_OPTIONS = {
    "--num_workers": "--total_worker_slots",
    "--multiprocessing_mode": "--max_active_problems",
    "--parallelism_mode": "elastic scheduling is always enabled",
}


def _positive_int(value: int) -> int:
    return max(1, int(value))


def _has_cli_option(raw_argv: Sequence[str], option: str) -> bool:
    for token in raw_argv:
        if not token.startswith("--"):
            continue
        if token.split("=", 1)[0] == option:
            return True
    return False


def _warn_config_translation(message: str) -> None:
    print(f"[parallelism] WARNING: {message}")


def _config_int(value: object, *, key: str) -> int:
    if isinstance(value, bool):
        return int(value)
    if isinstance(value, int):
        return value
    if isinstance(value, str):
        return int(value)
    raise TypeError(f"Config key '{key}' must be an integer-like value.")


def reject_legacy_cli_options(
    raw_argv: Sequence[str],
    *,
    runner_name: str,
    legacy_options: dict[str, str],
) -> None:
    used_options: list[str] = []
    for token in raw_argv:
        if not token.startswith("--"):
            continue
        option = token.split("=", 1)[0]
        if option in legacy_options:
            replacement = legacy_options[option]
            used_options.append(f"{option} -> {replacement}")

    if not used_options:
        return

    raise ValueError(
        f"{runner_name} no longer accepts legacy parallelism CLI options "
        f"({', '.join(used_options)}). Use the supported elastic controls directly. "
        "Older config files are still translated automatically."
    )


def _translate_legacy_config_key(
    *,
    args: argparse.Namespace,
    translated_config: dict[str, object],
    raw_argv: Sequence[str],
    legacy_key: str,
    target_key: str,
    target_option: str,
    mapped_value: int,
) -> None:
    if legacy_key not in translated_config:
        return

    translated_config.pop(legacy_key, None)
    if target_key in translated_config:
        _warn_config_translation(
            f"Config key '{legacy_key}' is deprecated and was ignored because "
            f"'{target_key}' is already set."
        )
        return

    translated_config[target_key] = mapped_value
    if _has_cli_option(raw_argv, target_option):
        _warn_config_translation(
            f"Config key '{legacy_key}' is deprecated. It maps to "
            f"'{target_key}={mapped_value}', but the explicit CLI value for "
            f"'{target_option}' takes precedence."
        )
        return

    setattr(args, target_key, mapped_value)
    _warn_config_translation(
        f"Config key '{legacy_key}' is deprecated. Translated it to "
        f"'{target_key}={mapped_value}'."
    )


def _translate_parallelism_mode_config(
    translated_config: dict[str, object],
) -> None:
    configured_mode = translated_config.pop("parallelism_mode", None)
    if configured_mode is None:
        return
    if str(configured_mode) == "elastic":
        _warn_config_translation(
            "Config key 'parallelism_mode' is deprecated and no longer needed. "
            "Elastic scheduling is always enabled."
        )
        return
    _warn_config_translation(
        f"Config key 'parallelism_mode: {configured_mode}' is deprecated. "
        "Elastic scheduling is now the only supported mode, so the setting "
        "was ignored."
    )


def translate_backend_legacy_parallelism_config(
    args: argparse.Namespace,
    *,
    config_from_file: dict[str, object] | None,
    raw_argv: Sequence[str],
) -> dict[str, object]:
    translated_config = dict(config_from_file or {})
    _translate_parallelism_mode_config(translated_config)

    legacy_num_workers = translated_config.get("num_workers")
    if legacy_num_workers is not None:
        mapped_workers = _positive_int(
            _config_int(legacy_num_workers, key="num_workers")
        )
        _translate_legacy_config_key(
            args=args,
            translated_config=translated_config,
            raw_argv=raw_argv,
            legacy_key="num_workers",
            target_key="total_worker_slots",
            target_option="--total_worker_slots",
            mapped_value=mapped_workers,
        )

    legacy_candidate_workers = translated_config.get("candidate_workers")
    if legacy_candidate_workers is not None:
        requested_workers = _config_int(
            legacy_candidate_workers,
            key="candidate_workers",
        )
        mapped_workers = max(1, requested_workers)
        if requested_workers <= 0:
            _warn_config_translation(
                "Config key 'candidate_workers' requested 0 or fewer workers. "
                "Elastic scheduling requires at least one worker per problem, "
                f"so it was translated to 'max_workers_per_problem={mapped_workers}'."
            )
        _translate_legacy_config_key(
            args=args,
            translated_config=translated_config,
            raw_argv=raw_argv,
            legacy_key="candidate_workers",
            target_key="max_workers_per_problem",
            target_option="--max_workers_per_problem",
            mapped_value=mapped_workers,
        )

    return translated_config


def translate_evolution_legacy_parallelism_config(
    args: argparse.Namespace,
    *,
    config_from_file: dict[str, object] | None,
    raw_argv: Sequence[str],
) -> dict[str, object]:
    translated_config = dict(config_from_file or {})
    _translate_parallelism_mode_config(translated_config)

    legacy_num_workers = translated_config.get("num_workers")
    if legacy_num_workers is not None:
        mapped_workers = _positive_int(
            _config_int(legacy_num_workers, key="num_workers")
        )
        _translate_legacy_config_key(
            args=args,
            translated_config=translated_config,
            raw_argv=raw_argv,
            legacy_key="num_workers",
            target_key="total_worker_slots",
            target_option="--total_worker_slots",
            mapped_value=mapped_workers,
        )

    legacy_mode = translated_config.pop("multiprocessing_mode", None)
    if legacy_mode is None:
        return translated_config
    if str(legacy_mode) == "problem":
        _warn_config_translation(
            "Config key 'multiprocessing_mode: problem' is deprecated. "
            "Elastic scheduling already spreads work across problems by default."
        )
        return translated_config
    if str(legacy_mode) != "candidate":
        _warn_config_translation(
            f"Config key 'multiprocessing_mode: {legacy_mode}' is deprecated and was ignored."
        )
        return translated_config
    if "max_active_problems" in translated_config:
        _warn_config_translation(
            "Config key 'multiprocessing_mode: candidate' is deprecated and was "
            "ignored because 'max_active_problems' is already set."
        )
        return translated_config

    translated_config["max_active_problems"] = 1
    if not _has_cli_option(raw_argv, "--max_active_problems"):
        args.max_active_problems = 1
    _warn_config_translation(
        "Config key 'multiprocessing_mode: candidate' is deprecated. "
        "Translated it to 'max_active_problems=1'."
    )
    return translated_config


@dataclass(frozen=True)
class ResolvedParallelismConfig:
    """Effective run-time parallelism configuration."""

    total_worker_slots: int
    max_active_problems: int
    max_workers_per_problem: int
    problem_processes: int
    candidate_worker_limit: int


@dataclass(frozen=True)
class ElasticParallelismHandles:
    """Shared Manager-backed state used by elastic problem controllers."""

    total_worker_slots: int
    lock: Any
    base_slots_in_use: Any
    extra_slots_in_use: Any
    active_problem_ids: Any
    problem_extra_slots: Any


@dataclass
class ElasticParallelismRuntime:
    """Parent-owned lifecycle wrapper for elastic coordination state."""

    config: ResolvedParallelismConfig
    handles: ElasticParallelismHandles
    _manager: Any

    @classmethod
    def create(cls, config: ResolvedParallelismConfig) -> ElasticParallelismRuntime:
        manager = multiprocessing.Manager()
        handles = ElasticParallelismHandles(
            total_worker_slots=config.total_worker_slots,
            lock=manager.RLock(),
            base_slots_in_use=manager.Value("i", 0),
            extra_slots_in_use=manager.Value("i", 0),
            active_problem_ids=manager.dict(),
            problem_extra_slots=manager.dict(),
        )
        return cls(config=config, handles=handles, _manager=manager)

    def close(self) -> None:
        manager = self._manager
        if manager is None:
            return
        self._manager = None
        manager.shutdown()


class ElasticSlotCoordinator:
    """Minimal shared-state helper for elastic slot accounting."""

    def __init__(self, handles: ElasticParallelismHandles) -> None:
        self._handles = handles

    def open_problem(self, problem_id: str) -> None:
        if not problem_id:
            return
        with self._handles.lock:
            if problem_id in self._handles.active_problem_ids:
                return
            self._handles.active_problem_ids[problem_id] = True
            self._handles.base_slots_in_use.value += 1

    def close_problem(self, problem_id: str) -> None:
        if not problem_id:
            return
        with self._handles.lock:
            leaked_extra_slots = int(self._handles.problem_extra_slots.pop(problem_id, 0))
            if problem_id in self._handles.active_problem_ids:
                del self._handles.active_problem_ids[problem_id]
                self._handles.base_slots_in_use.value = max(
                    0,
                    int(self._handles.base_slots_in_use.value) - 1,
                )
            if leaked_extra_slots > 0:
                self._handles.extra_slots_in_use.value = max(
                    0,
                    int(self._handles.extra_slots_in_use.value) - leaked_extra_slots,
                )

    def try_acquire_extra_slots(self, problem_id: str, requested_slots: int) -> int:
        if requested_slots <= 0:
            return 0
        with self._handles.lock:
            if problem_id not in self._handles.active_problem_ids:
                return 0
            available_slots = (
                self._handles.total_worker_slots
                - int(self._handles.base_slots_in_use.value)
                - int(self._handles.extra_slots_in_use.value)
            )
            if available_slots <= 0:
                return 0
            granted_slots = min(int(requested_slots), int(available_slots))
            if granted_slots <= 0:
                return 0
            owned_slots = int(self._handles.problem_extra_slots.get(problem_id, 0))
            self._handles.problem_extra_slots[problem_id] = owned_slots + granted_slots
            self._handles.extra_slots_in_use.value += granted_slots
            return granted_slots

    def release_extra_slots(self, problem_id: str, slots: int) -> None:
        if slots <= 0:
            return
        with self._handles.lock:
            owned_slots = int(self._handles.problem_extra_slots.get(problem_id, 0))
            released_slots = min(int(slots), owned_slots)
            if released_slots <= 0:
                return
            remaining_slots = owned_slots - released_slots
            if remaining_slots > 0:
                self._handles.problem_extra_slots[problem_id] = remaining_slots
            else:
                self._handles.problem_extra_slots.pop(problem_id, None)
            self._handles.extra_slots_in_use.value = max(
                0,
                int(self._handles.extra_slots_in_use.value) - released_slots,
            )

    def snapshot(self) -> dict[str, object]:
        with self._handles.lock:
            return {
                "total_worker_slots": int(self._handles.total_worker_slots),
                "base_slots_in_use": int(self._handles.base_slots_in_use.value),
                "extra_slots_in_use": int(self._handles.extra_slots_in_use.value),
                "active_problem_ids": sorted(self._handles.active_problem_ids.keys()),
                "problem_extra_slots": dict(self._handles.problem_extra_slots),
            }


class ProblemConcurrencyController:
    """Per-problem interface used by runners and engines."""

    def open_problem(self) -> None:
        return None

    def close_problem(self) -> None:
        return None

    @contextlib.contextmanager
    def lease_candidate_workers(self, batch_size: int) -> Iterator[int]:
        yield 1


class FixedProblemConcurrencyController(ProblemConcurrencyController):
    """Static per-problem worker cap used by simple fallback runs."""

    def __init__(self, max_workers: int) -> None:
        self._max_workers = _positive_int(max_workers)

    @contextlib.contextmanager
    def lease_candidate_workers(self, batch_size: int) -> Iterator[int]:
        if batch_size <= 1:
            yield 1
            return
        yield min(self._max_workers, int(batch_size))


class ElasticProblemConcurrencyController(ProblemConcurrencyController):
    """Per-problem elastic controller backed by shared slot accounting."""

    def __init__(
        self,
        *,
        problem_id: str,
        handles: ElasticParallelismHandles,
        max_workers_per_problem: int,
    ) -> None:
        self._problem_id = problem_id
        self._coordinator = ElasticSlotCoordinator(handles)
        self._max_workers_per_problem = _positive_int(max_workers_per_problem)
        self._opened = False

    def open_problem(self) -> None:
        if self._opened:
            return
        self._coordinator.open_problem(self._problem_id)
        self._opened = True

    def close_problem(self) -> None:
        if not self._opened:
            return
        self._coordinator.close_problem(self._problem_id)
        self._opened = False

    @contextlib.contextmanager
    def lease_candidate_workers(self, batch_size: int) -> Iterator[int]:
        target_workers = min(
            _positive_int(batch_size),
            self._max_workers_per_problem,
        )
        if target_workers <= 1:
            yield 1
            return

        granted_extra_slots = self._coordinator.try_acquire_extra_slots(
            self._problem_id,
            target_workers - 1,
        )
        effective_workers = 1 + granted_extra_slots
        try:
            yield effective_workers
        finally:
            self._coordinator.release_extra_slots(
                self._problem_id,
                granted_extra_slots,
            )


def build_problem_concurrency_controller(
    config: ResolvedParallelismConfig,
    *,
    problem_id: str,
    handles: ElasticParallelismHandles | None = None,
) -> ProblemConcurrencyController:
    if handles is None:
        return FixedProblemConcurrencyController(config.candidate_worker_limit)
    return ElasticProblemConcurrencyController(
        problem_id=problem_id,
        handles=handles,
        max_workers_per_problem=config.max_workers_per_problem,
    )


def build_elastic_parallelism_runtime(
    config: ResolvedParallelismConfig,
    *,
    task_count: int,
) -> ElasticParallelismRuntime | None:
    if task_count <= 1:
        return None
    if config.problem_processes <= 1:
        return None
    return ElasticParallelismRuntime.create(config)


def apply_resolved_parallelism_args(
    args: argparse.Namespace,
    config: ResolvedParallelismConfig,
) -> argparse.Namespace:
    args.total_worker_slots = config.total_worker_slots
    args.max_active_problems = config.max_active_problems
    args.max_workers_per_problem = config.max_workers_per_problem
    return args


def resolve_backend_parallelism_config(
    args: argparse.Namespace,
    *,
    task_count: int,
) -> ResolvedParallelismConfig:
    total_worker_slots = _positive_int(args.total_worker_slots)
    max_active_problems = (
        _positive_int(args.max_active_problems)
        if args.max_active_problems is not None
        else total_worker_slots
    )
    max_workers_per_problem = (
        _positive_int(args.max_workers_per_problem)
        if args.max_workers_per_problem is not None
        else total_worker_slots
    )
    return ResolvedParallelismConfig(
        total_worker_slots=total_worker_slots,
        max_active_problems=max_active_problems,
        max_workers_per_problem=max_workers_per_problem,
        problem_processes=min(task_count, total_worker_slots, max_active_problems),
        candidate_worker_limit=max_workers_per_problem,
    )


def resolve_evolution_parallelism_config(
    args: argparse.Namespace,
    *,
    task_count: int,
) -> ResolvedParallelismConfig:
    if args.evaluation_mode == "gen0":
        return ResolvedParallelismConfig(
            total_worker_slots=1,
            max_active_problems=1,
            max_workers_per_problem=1,
            problem_processes=1,
            candidate_worker_limit=1,
        )

    total_worker_slots = _positive_int(args.total_worker_slots)
    max_active_problems = (
        _positive_int(args.max_active_problems)
        if args.max_active_problems is not None
        else total_worker_slots
    )
    max_workers_per_problem = (
        _positive_int(args.max_workers_per_problem)
        if args.max_workers_per_problem is not None
        else total_worker_slots
    )
    return ResolvedParallelismConfig(
        total_worker_slots=total_worker_slots,
        max_active_problems=max_active_problems,
        max_workers_per_problem=max_workers_per_problem,
        problem_processes=min(task_count, total_worker_slots, max_active_problems),
        candidate_worker_limit=max_workers_per_problem,
    )

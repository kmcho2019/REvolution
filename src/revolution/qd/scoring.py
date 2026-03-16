from __future__ import annotations

import hashlib
from typing import Literal

CircuitType = Literal["sequential", "combinational", "unknown"]
QualityMode = Literal["ppa", "functional_only"]

_STAGE_RANK = {
    "failed_format": 0.0,
    "failed_diff": 1.0,
    "failed_syntax": 2.0,
    "failed_functionality": 3.0,
    "failed_synthesis": 4.0,
    "failed_synthesis_functionality": 5.0,
    "skipped_synthesis": 5.5,
    "success": 6.0,
}


def normalize_code_hash(source: str) -> str:
    """Return a stable content hash used for duplicate detection."""

    normalized = source.replace("\r\n", "\n").strip()
    return hashlib.sha256(normalized.encode("utf-8")).hexdigest()


def default_ppa_weights(circuit_type: CircuitType) -> tuple[float, float, float]:
    """Return default REvolution PPA weights for one circuit type."""

    if circuit_type == "combinational":
        return 0.5, 0.5, 0.0
    return (1.0 / 3.0, 1.0 / 3.0, 1.0 / 3.0)


def _normalized_gain(
    ref_value: float | None,
    gen_value: float | None,
    *,
    eps: float = 1e-12,
) -> float | None:
    if ref_value is None or gen_value is None:
        return None
    denom = max(abs(float(ref_value)), eps)
    return (float(ref_value) - float(gen_value)) / denom


def compute_ppa_gains(
    ppa_metrics: dict[str, float],
    ref_ppa_metrics: dict[str, float],
) -> dict[str, float]:
    """Compute normalized PPA gain axes against the reference design."""

    gains: dict[str, float] = {}
    for metric_name, axis_name in (
        ("power", "g_P"),
        ("area", "g_A"),
        ("eff_clk_period", "g_T"),
    ):
        gain = _normalized_gain(ref_ppa_metrics.get(metric_name), ppa_metrics.get(metric_name))
        if gain is not None:
            gains[axis_name] = gain
    return gains


def compute_quality_score(
    ppa_metrics: dict[str, float],
    ref_ppa_metrics: dict[str, float],
    *,
    circuit_type: CircuitType,
    alpha: float | None = None,
    beta: float | None = None,
    gamma: float | None = None,
) -> tuple[float, dict[str, float]]:
    """Compute the maximize-form QD quality score and its components."""

    default_alpha, default_beta, default_gamma = default_ppa_weights(circuit_type)
    alpha = default_alpha if alpha is None else float(alpha)
    beta = default_beta if beta is None else float(beta)
    gamma = default_gamma if gamma is None else float(gamma)

    gains = compute_ppa_gains(ppa_metrics, ref_ppa_metrics)
    components = {
        "g_P": gains.get("g_P", 0.0),
        "g_A": gains.get("g_A", 0.0),
        "g_T": gains.get("g_T", 0.0),
        # Backward-compatible aliases for existing reporting/tests.
        "power_improvement": gains.get("g_P", 0.0),
        "area_improvement": gains.get("g_A", 0.0),
        "timing_improvement": gains.get("g_T", 0.0),
        "alpha": alpha,
        "beta": beta,
        "gamma": gamma,
    }
    quality_score = alpha * components["g_P"] + beta * components["g_A"] + gamma * components["g_T"]
    return quality_score, components


def compute_partial_pass_fraction(stage_statuses: dict[str, bool]) -> float:
    """Return the fraction of evaluation stages passed by one candidate."""

    if not stage_statuses:
        return 0.0
    true_count = sum(1 for passed in stage_statuses.values() if passed)
    return true_count / max(len(stage_statuses), 1)


def compute_repair_score(
    status: str,
    *,
    stage_statuses: dict[str, bool],
    partial_pass_fraction: float | None = None,
    duplicate_signature_penalty: float = 0.0,
    age_penalty: float = 0.0,
) -> float:
    """Score a failing candidate for fail-pool prioritization."""

    stage_rank = _STAGE_RANK.get(status, 0.0)
    partial = (
        compute_partial_pass_fraction(stage_statuses)
        if partial_pass_fraction is None
        else float(partial_pass_fraction)
    )
    return stage_rank + partial - float(duplicate_signature_penalty) - float(age_penalty)


def functional_quality_score(
    *,
    functional_score: float,
    structural_metrics: dict[str, float] | None = None,
) -> tuple[float, dict[str, float]]:
    """Build a functional-only quality score with structural tiebreak fields."""

    structural_metrics = structural_metrics or {}
    components = {
        "functional_score": float(functional_score),
        "cell_count_tiebreak": -float(structural_metrics.get("cell_count_log", 0.0)),
        "ltp_tiebreak": -float(structural_metrics.get("ltp_noff", 0.0)),
    }
    return components["functional_score"], components

from __future__ import annotations

from collections import Counter

import pytest

from revolution.qd.types import ArchiveMember
from revolution.qd_natural import curiosity_pool
from revolution.qd_natural.engine import NaturalQDEngine


def _member(
    candidate_id: str, g_p: float, g_a: float, insertion_index: int
) -> ArchiveMember:
    return ArchiveMember(
        candidate_id=candidate_id,
        descriptors=(0.0,),
        quality_score=(g_p + g_a) / 2.0,
        objectives={"g_P": g_p, "g_A": g_a},
        payload=f"payload-{candidate_id}",
        insertion_index=insertion_index,
    )


def test_empty_archive_returns_empty_pool() -> None:
    assert curiosity_pool([], ("g_P", "g_A"), 4, 1.0) == ([], [])


def test_pool_keeps_nsga2_order_and_cap() -> None:
    members = [
        ("cell_a", _member("dominated", 0.1, 0.1, 0)),
        ("cell_a", _member("front_left", 0.9, 0.2, 1)),
        ("cell_b", _member("front_right", 0.2, 0.9, 2)),
    ]
    pool, weights = curiosity_pool(members, ("g_P", "g_A"), 2, 1.0)
    # Rank 1 = the two front members; the dominated one is trimmed by the cap.
    assert pool == ["payload-front_left", "payload-front_right"]
    assert len(weights) == 2


def test_weights_favor_underpopulated_cells() -> None:
    # crowded cell has 3 members, sparse cell has 1; all mutually non-dominated
    members = [
        ("crowded", _member("c1", 0.9, 0.1, 0)),
        ("crowded", _member("c2", 0.8, 0.2, 1)),
        ("crowded", _member("c3", 0.7, 0.3, 2)),
        ("sparse", _member("s1", 0.1, 0.95, 3)),
    ]
    pool, weights = curiosity_pool(members, ("g_P", "g_A"), 4, 1.0)
    by_payload = dict(zip(pool, weights, strict=True))
    assert by_payload["payload-s1"] == pytest.approx(1.0)
    for crowded_id in ("c1", "c2", "c3"):
        assert by_payload[f"payload-{crowded_id}"] == pytest.approx(1.0 / 3.0)


def test_gamma_scales_the_bias() -> None:
    members = [
        ("crowded", _member("c1", 0.9, 0.1, 0)),
        ("crowded", _member("c2", 0.8, 0.2, 1)),
        ("sparse", _member("s1", 0.1, 0.95, 2)),
    ]
    _, weights_half = curiosity_pool(members, ("g_P", "g_A"), 3, 0.5)
    _, weights_full = curiosity_pool(members, ("g_P", "g_A"), 3, 1.0)
    # gamma=0.5 softens the crowded-cell penalty relative to gamma=1.0
    assert weights_half[0] == pytest.approx((1.0 / 2.0) ** 0.5)
    assert weights_full[0] == pytest.approx(0.5)
    assert weights_half[0] > weights_full[0]


def test_gamma_must_be_positive() -> None:
    with pytest.raises(AssertionError):
        curiosity_pool([], ("g_P",), 1, 0.0)


def test_occupancy_counts_full_archive_not_pool() -> None:
    # The dominated member is trimmed from the pool but still counts toward
    # its cell's occupancy.
    members = [
        ("cell_a", _member("front", 0.9, 0.9, 0)),
        ("cell_a", _member("dominated", 0.1, 0.1, 1)),
    ]
    pool, weights = curiosity_pool(members, ("g_P", "g_A"), 1, 1.0)
    assert pool == ["payload-front"]
    assert weights[0] == pytest.approx(0.5)


def test_engine_subclasses_qd_engine_and_requires_nsga2() -> None:
    from revolution.qd import QDEngine

    assert issubclass(NaturalQDEngine, QDEngine)
    # The override composes only with the V2 selection rule; the ctor
    # assertion is exercised end-to-end by the backend engine-selection test.
    assert NaturalQDEngine._sample_success_parents is not QDEngine._sample_success_parents


def test_draw_distribution_respects_weights() -> None:
    import random

    members = [
        ("crowded", _member("c1", 0.9, 0.1, 0)),
        ("crowded", _member("c2", 0.8, 0.2, 1)),
        ("crowded", _member("c3", 0.7, 0.3, 2)),
        ("sparse", _member("s1", 0.1, 0.95, 3)),
    ]
    pool, weights = curiosity_pool(members, ("g_P", "g_A"), 4, 1.0)
    random.seed(1001)
    draws = Counter(random.choices(pool, weights=weights, k=4000))
    # sparse cell weight 1.0 vs 1/3 each: expect ~2000 sparse draws of 4000
    assert 1700 < draws["payload-s1"] < 2300

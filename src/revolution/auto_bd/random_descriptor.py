from __future__ import annotations

import hashlib

RANDOM_DESCRIPTOR_SEED = "20260618_auto_bd_random_descriptor"
RANDOM_HASH_AXES = ("random_hash_0", "random_hash_1", "random_hash_2")


def random_hash_descriptor_values(source_hash: str) -> dict[str, float]:
    """Map a canonical candidate hash to deterministic pseudo-random axes."""

    assert source_hash
    return {axis: _unit_interval(source_hash, axis) for axis in RANDOM_HASH_AXES}


def _unit_interval(source_hash: str, axis: str) -> float:
    digest = hashlib.sha256(
        f"{RANDOM_DESCRIPTOR_SEED}:{axis}:{source_hash}".encode("utf-8")
    ).hexdigest()
    return int(digest[:16], 16) / float(16**16)

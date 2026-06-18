from revolution.auto_bd.random_descriptor import (
    RANDOM_HASH_AXES,
    random_hash_descriptor_values,
)


def test_random_hash_descriptor_is_deterministic_and_bounded():
    first = random_hash_descriptor_values("abc123")
    second = random_hash_descriptor_values("abc123")

    assert first == second
    assert tuple(first) == RANDOM_HASH_AXES
    assert all(0.0 <= value < 1.0 for value in first.values())


def test_random_hash_descriptor_changes_with_source_hash():
    assert random_hash_descriptor_values("abc123") != random_hash_descriptor_values(
        "def456"
    )

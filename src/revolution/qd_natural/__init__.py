"""Natural QD push variants (2026-07-03): self-contained QDEngine subclasses.

Lane N02 lives here so the shared QD engine stays untouched; see
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/.
"""

from revolution.qd_natural.engine import NaturalQDEngine, curiosity_pool

__all__ = ["NaturalQDEngine", "curiosity_pool"]

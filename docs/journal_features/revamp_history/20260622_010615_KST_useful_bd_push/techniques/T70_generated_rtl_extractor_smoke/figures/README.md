# T70 Figures

## Pass Rate

`t70_generated_rtl_extractor_smoke.png` shows parse pass rate for MasterRTL SOG
and RTL-Timer SOG BOG extraction over the deterministic T70 sample. Every group
passes at `100%`.

## Output Richness

`t70_extractor_richness_by_candidate.png` shows that successful parsing is not
empty work. MasterRTL graph edges vary by candidate from small FSM-like designs
to larger ALU logic, while RTL-Timer DFF references identify sequential
structure in pipeline, FSM, traffic-light, parallel-to-serial, and signal
generator candidates.

Visual inspection note: both figures are legible at report scale. The pass-rate
figure is intentionally simple; the richness figure carries the more detailed
evidence.

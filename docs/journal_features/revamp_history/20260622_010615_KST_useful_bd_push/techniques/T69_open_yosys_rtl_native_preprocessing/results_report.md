# T69 Open-Yosys RTL-Native Preprocessing Results

## Tier Decision

`T0 preprocessing_unblocker`.

T69 upgrades the T68 status from "fresh conversion blocked by Verific" to
"fresh TinyRocket conversion works with a narrow open-source Yosys adaptation."
It does not prove QD usefulness and does not change any PPA claim.

## Evidence

| Evidence | Shipped | Open clean | Delta |
| --- | ---: | ---: | ---: |
| MasterRTL graph keys | `22306` | `22061` | `-1.098%` |
| MasterRTL graph edges | `65938` | `65454` | `-0.734%` |
| MasterRTL node dict entries | `51337` | `51128` | `-0.407%` |
| RTL-Timer SOG BOG assigns | `1236` | `1239` | `+0.243%` |
| RTL-Timer SOG BOG wires | `24079` | `24136` | `+0.237%` |
| RTL-Timer SOG BOG DFF refs | `2431` | `2431` | `0.000%` |

The summary figure is
`figures/t69_open_yosys_preprocessing_alignment.png`.

## What Worked

MasterRTL TinyRocket conversion works without Verific when the command keeps
the upstream read and lowering stages but omits `read -verific`. The raw
generated file initially failed PyVerilog parsing because Yosys emitted inline
attributes inside expressions. Removing generated attributes with the same
style of cleanup used by the upstream flows allowed `vlg2ir/analyze.py` to
produce graph and node-dictionary pickles.

RTL-Timer TinyRocket SOG BOG conversion also works without Verific when using
the source-consistent `cmd=sog` mapping and `nangate45_sog.lib`. The cleaned
open-source output preserves the shipped DFF-reference count exactly and has
very small assign and wire count differences.

## What Still Does Not Work

This is not yet a working descriptor for our live RTL candidates. We have not
run MasterRTL or RTL-Timer preprocessing over REvolution-generated Verilog, and
we have not measured extractor failure modes on malformed or partial candidate
RTL. We also have not loaded a meaningful RTL-Timer checkpoint; T68 found no
obvious packaged RTL-Timer model weights.

## Decision

Treat T69 as the next RTL-native source-alignment step. The next technique
should use the T69 preprocessing path on a small live-candidate sample and
report:

- candidate-level extractor success rate;
- descriptor distributions by design;
- archive-cell occupancy and duplicate accounting;
- reference-complete classic-versus-QD PPA metrics if used in a live run.

Do not describe T15/T60/T61/T62 proxy features as true MasterRTL or RTL-Timer
results. T69 makes a source-aligned path plausible, but it has not yet been
validated on the target candidate distribution.

# Candidate Config Shortlist

This is not a promotion list. It is the current set of representatives a
senior reviewer should inspect when proposing the next variant.

| Category | Representative | Why inspect it |
| --- | --- | --- |
| Classic baseline | `classic_revolution_8x5` | Strong comparator and likely source of useful selection pressure. |
| MasterRTL RF | `T83_rf_leafid_structural_delayed_qd` | Closest single-seed near miss; replication blocks promotion. |
| Archive timing | `masterrtl_delayed_archive_activation_8x5` | Best evidence that delaying QD pressure helps. |
| Pure DeepGate | `T95_deepgate_delayed_high_exploit_8x5` | Best official DeepGate representative. |
| RF/DeepGate hybrid | `T96_rf_deepgate_hybrid_delayed_8x5` | Tests whether RTL-native and netlist embeddings complement each other. |
| AURORA/raw impl | `T99_aurora_raw_impl_delayed_qd` | Best live AURORA-style learned/raw implementation lane. |
| Qwen3 RTL | `qwen_canonical_rtl_pca3_8x5` | Best actual text/code pretrained embedding representative, but weak. |
| FG-QDM memory | `T100_fg_qdm_rf_leafid_front_credit_12x3` | Best auxiliary-memory smoke; front-rescue added front material. |
| SR/code-thought | `T51_code_thought_front_slot_qd` | Useful custom mechanism evidence with yield/HV-AUC recovery. |
| Replay graph lane | `T36_t11_bounded_front_lane_bd` | Strong replay signal that did not transfer cleanly live. |

Potential next full-run candidates should probably be derived from:

1. `T83` plus better schedule or adaptive trigger;
2. `T100` after a frozen `8x5` preflight;
3. a hybrid of classic hill climbing plus very light QD tie-breaks;
4. a trained descriptor objective based on future front contribution;
5. an adaptive restart method where diversity chooses restart parents, not
   every generation's main parent pool.

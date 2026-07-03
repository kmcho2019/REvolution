# Adversarial Q&A Review

This file simulates likely colleague questions and checks whether the deck can
answer them from visible slides or appendix material.

## Round 1 - Claim Strength

**Q: Are you claiming PCN-v3 is statistically better than classic?**

Answer from deck: no. Slides 3, 16, 23, and 24 say the positive PCN result is
one-seed evidence and the 20260701 material is smoke-level only. Appendix
caveats repeat that final statistical claims require the five-seed C-F
ablation.

**Q: Why is the 20260629 negative result not enough to reject QD?**

Answer from deck: slides 12 and 13 show two confounds: QD arms used a weaker
operator path and often displaced classic hill-climbing with archive sampling.
The appendix records exact `single_thought_operator` wrapper flags.

**Q: Is the 20260630 PCN win memory, or just C-F removal?**

Answer from deck: slide 17 now states the no-C-F caveat; slide 22 explains the
C-F ablation design. Appendix implementation cross-check lists the exact
operator-set flags. This is answerable, but the honest answer is still
pending the full five-seed run.

## Round 2 - Method Mechanics

**Q: What does PCN do that classic does not?**

Answer from deck: slides 14, 17, 18, and appendix PCN section. PCN keeps a
classic primary success pool, passively inserts valid-PPA candidates into
descriptor memory, and spends a small gated memory-refine lane.

**Q: Does PCN ask the LLM to target arbitrary descriptor coordinates?**

Answer from deck: appendix says no. The memory instruction asks for PPA
improvement while preserving interface/functionality and explicitly says not
to restructure solely for diversity.

**Q: How do we know the memory lane actually fired?**

Answer from deck: slide 18 gives counts: `86` memory-refine candidates, `62`
valid-PPA, `9` local-front additions, `5` global-front additions.

## Round 3 - Descriptor And Encoder Legitimacy

**Q: Which pretrained encoder actually worked best?**

Answer from deck: slides 8, 11, 20, and appendix. Strict pretrained text/code
Qwen3 improved after EoH correction but stayed below classic. The strongest
signal is not a pure pretrained encoder; it is PCN with RF/MasterRTL/RTLTimer
style descriptor state.

**Q: Are you overclaiming MasterRTL or RTLTimer pretrained inference?**

Answer from deck: appendix warns not to overclaim full upstream predictor
reproduction. The presentation frames these as source-aligned/model-state
descriptor lanes unless separate weight-path validation is shown.

**Q: Why is Qwen3 still worth showing if it loses?**

Answer from deck: slide 20 shows a major operator correction effect from
43.1% to 89.5% HV retention. This supports the broader lesson that operator
machinery mattered, even though Qwen3 remains below classic.

**Q: What exactly does "canonical" mean in Qwen canonical RTL?**

Answer from deck: appendix glossary and Qwen sections. It means comments are
removed, identifiers are role-normalized, whitespace is normalized, and the
stable RTL text is embedded by Qwen. It does not mean semantic equivalence or
post-synthesis canonicalization.

**Q: What is an RF leaf ID, and why is that an encoder-like descriptor?**

Answer from deck: appendix glossary and MasterRTL RF section. RF means random
forest. A leaf ID is the tree leaf reached by extracted timing-path features.
Counting unique leaf IDs/rows describes which learned timing-model regions a
candidate touches, without directly using the scalar timing prediction as the
optimization target.

**Q: What are MasterRTL/RTLTimer-inspired features?**

Answer from deck: appendix descriptor-feature glossary. They are
source-aligned graph and timing-structure counts such as branching, DFF
density, wire density, mux fraction, XOR fraction, and RF timing leaf-state
summaries. The deck explicitly avoids claiming full upstream predictor
reproduction.

**Q: What does "implementation-level structural feature" mean?**

Answer from deck: appendix AURORA/descriptor glossary. It means compact
features from synthesized/evaluated implementation summaries, for example
combinational-cell ratio, adder-cell ratio, and log cell count. These features
describe implementation family coarsely and are not PPA objectives.

## Round 4 - Experimental Validity

**Q: Were reference-missing RTLLM designs included in headline HV?**

Answer from deck: slides 8 and appendix state headline metrics use the 46
reference-complete RTLLM designs. Evidence map repeats this.

**Q: Did missing candidate PPA get silently dropped?**

Answer from deck: appendix states missing candidate PPA is counted as invalid
for that method.

**Q: Is smoke evidence being used as final evidence?**

Answer from deck: no. Slides 3, 22, and 23 label 20260701 as smoke-level
operator validation, not final performance proof.

## Remaining Weak Points To Say Out Loud

- The current deck is a preliminary presentation, not the final PCN statistical
  report.
- The strongest PCN claim must compare against `classic_no_cf_8x5`, not only
  original classic.
- A full MasterRTL/RTLTimer pretrained-model claim would need a separate
  upstream-weight reproduction audit.

# Reviewer Questions

Please review the bundle as if advising whether this TCAD extension should
continue as a positive QD/MAP-Elites paper, pivot to a diagnostic/negative
study, or be reframed around a narrower mechanism.

## Core Research Questions

1. Does the current evidence show that diversity-based RTL evolution works?
2. Does it show enough promise to justify more full-suite vLLM runs?
3. Are the current negative results strong enough to pivot the claim?
4. Is the current acceptance standard too strict, too loose, or mismatched to
   QD research?

## Algorithm Questions

1. Are we using MAP-Elites in the wrong role for expensive LLM-based RTL
   generation?
2. Should QD be auxiliary memory rather than primary selection pressure?
3. Should archive cells keep local Pareto fronts, one elite, or staged elites?
4. Should diversity pressure activate only after classic stagnates?
5. Is the `8x5` or `12x3` budget shape reasonable for a decisive test, or is
   the budget too small to answer the question?

## Descriptor Questions

1. Which descriptor family is most credible for RTL PPA evolution:
   synthesis-response, RTL-native MasterRTL/RTLTimer features, graph/netlist
   encoders, pretrained text embeddings, or hybrid descriptors?
2. Are synthesis-response descriptors too close to the downstream objective,
   or are they valid because they avoid final PPA and reference labels?
3. Are Qwen/text embeddings too opaque and problem-identity dominated?
4. Are graph/netlist encoders worth another attempt after the replay-to-live
   gap?
5. Should pretrained MasterRTL/RTLTimer/DeepGate paths be required before
   claiming encoder-based results?

## Experimental Design Questions

1. Is the proposed selected-config RTLLM test sufficient to decide whether to
   continue?
2. Should the benchmark be full RTLLM, a reference-complete RTLLM subset, or a
   discriminative medium-validity subset?
3. Should we require multi-seed results before making any claim, or is a
   broad one-seed RTLLM comparison acceptable as engineering evidence?
4. Is HV/HV-AUC the right primary metric, or should another QD/Pareto metric
   be primary?
5. How should missing reference `ppa.txt` and candidate-missing PPA be handled?

## Paper-Framing Questions

1. Would a paper saying "generic QD does not beat classic in this setting" be
   useful if it includes a careful map of which descriptors failed and why?
2. Is the stronger claim "useful RTL diversity means PPA-competitive
   implementation-family preservation" compelling?
3. Should the TCAD extension emphasize negative results, algorithmic lessons,
   or one more selected-config positive attempt?
4. What would a reviewer consider the minimum convincing evidence that
   QD/MAP-Elites is worth using for RTL PPA evolution?

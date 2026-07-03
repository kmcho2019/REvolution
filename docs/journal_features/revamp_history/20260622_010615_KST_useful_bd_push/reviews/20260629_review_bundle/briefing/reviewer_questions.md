# Reviewer Questions

Please answer as concretely as possible.

## Search Algorithm

1. What is the most plausible hybrid algorithm that keeps classic's
   hill-climbing strength but uses QD enough to make a measurable difference?
2. Should QD act as an archive for parent recall, a restart policy, a
   tie-breaker, a training signal, or a separate emitter?
3. How should memory/archive cells earn future budget?
4. When should diversity pressure turn on or off?
5. What minimum mechanism metric should we require before a full RTLLM run?

## Descriptor And Encoder Design

1. Which descriptor family is most likely to separate useful RTL
   implementation families rather than surface syntax?
2. Should we train a descriptor using previous candidates and future PPA-front
   contribution labels?
3. Should Qwen3, DeepGate, MasterRTL, or AURORA features be used directly,
   clustered, residualized, or only as secondary coordinates?
4. Is a learned uncertainty or novelty score more useful than archive cells?
5. How can we prevent descriptor leakage while still exploiting PPA feedback
   for selection?

## Experiment Design

1. Which 6-12 designs should be used as the next discriminative screen?
2. Should we change from `8x5` to a deeper budget before judging QD?
3. Which result would justify full RTLLM spend despite recent negatives?
4. Which existing variants should be retired permanently?
5. What is the fastest decisive experiment that can reveal a path to beating
   classic HV?

## Anti-Gaming

1. What loopholes might let us fake a QD win without real PPA-front progress?
2. What metrics should be headline versus diagnostic?
3. How should missing reference PPA, invalid candidates, duplicates, and
   design-specific effects be handled?
4. How much validity loss is acceptable if HV improves?
5. How should single-seed results be treated under deadline pressure?

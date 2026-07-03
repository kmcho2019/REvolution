# Cover Letter To Senior Reviewers

We need help finding a QD-compatible method that can outperform, or at least
come very close to, classic REvolution on RTL PPA hypervolume.

Recent work produced a rigorous negative map rather than a positive QD result.
The best current methods are informative but still trail classic on
reference-complete HV and Pareto-front breadth. We are therefore asking for a
senior review focused on new ideas, not another sign-off of the negative map.

The key question:

> How should we modify the search algorithm, descriptor objective, archive use,
> or benchmark/evaluation strategy so that some form of diversity helps improve
> RTL PPA optimization beyond classic REvolution?

We are open to QD being used lightly. It does not need to be full MAP-Elites.
Useful answers may propose hybrid hill climbing, QD as auxiliary memory,
novelty as a tie-breaker, adaptive restarts, learned emitters, trained
descriptors, front-rescue policies, or other search mechanisms that preserve
classic's exploitation strength.

Please prioritize concrete, testable recommendations:

- one or more algorithm variants worth implementing next;
- the minimum screening run that would falsify or support each variant;
- what existing evidence suggests the variant could beat classic;
- what risks or reward-hacking loopholes must be blocked;
- whether the idea should be tested on RTLLM full suite, a discriminative
  subset, or a smaller mechanism smoke first.

The most important evidence files are listed in `README.md` and summarized in
the briefing documents.

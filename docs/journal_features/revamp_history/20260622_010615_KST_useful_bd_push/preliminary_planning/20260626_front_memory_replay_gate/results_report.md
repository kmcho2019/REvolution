# Front-Memory Replay Results

Scalar retention uses top-8 by `score_from_run`.

## Backend Summary

| Backend | Problems | Final Front | Evicted Final Front | Evicted Rate | Birth Misses | Birth Miss Rate |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| classic_revolution_8x5 | 8 | 54 | 14 | 0.259259 | 6 | 0.111111 |
| rf_deepgate_hybrid_delayed_8x5 | 8 | 81 | 55 | 0.679012 | 36 | 0.444444 |

## Result

- `classic_revolution_8x5` leaves `14/54` final-front candidates outside final scalar top-k.
- `rf_deepgate_hybrid_delayed_8x5` leaves `55/81` final-front candidates outside final scalar top-k.

## Decision

This replay is a mechanism gate, not a QD promotion. Scalar top-k
does discard final-front material, so a memory mechanism has
something real to retain. However, the QD hybrid has a much larger
retention gap while still losing HV and Pareto breadth to classic.
The next live method should therefore not broaden archive recall by
itself. It should spend memory budget only when a retained family
has evidence of producing quality-improving or front-adding
children, and it should report front-add rate per memory-lane call.

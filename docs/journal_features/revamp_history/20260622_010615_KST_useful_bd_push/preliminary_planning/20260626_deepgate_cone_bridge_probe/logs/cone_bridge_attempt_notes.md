# Cone Bridge Attempt Notes

- Initial implementation selected the largest bounded cones under a `700`-AND
  cap. The first selected cone entered the official `aiger` parser path for
  several minutes and was interrupted.
- The script was changed to select the smallest nontrivial bounded cones first.
  With the same `700`-AND cap and `3` cones per large row, the full probe
  completed in about `12s`.
- The final selected cones are small enough for the official DeepGate parser:
  max selected cone size is `245` ANDs and max embedding time is `0.0710s`.

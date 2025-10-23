module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Deriving the logic for Y1:
// - From state A, if w is 1, go to B, else stay in A. Y1 should be high when going to B.
// - From state B, if w is 1, go to C, else go to D. Y1 should be high when going to D.
// - From state C, if w is 1, go to E, else go to D. Y1 should be high when going to D.
// - From state D, if w is 1, go to F, else go to A. Y1 should be high when going to D from B or C.
// - From state E, if w is 1, stay in E, else go to D. Y1 should be high when going to D.
// - From state F, if w is 1, go to C, else go to D. Y1 should be high when going to D.
// Since the only next states where Y1 is 1 are B and D, and considering the one-hot encoding,
// Y1 is 1 when the current state is A and w=1 (next state B), or when the current state is B and w=0 (next state D),
// or when the current state is C and w=0 (next state D), or when the current state is D and w=0 (but D doesn't have y[1]=1),
// or when the current state is E and w=0 (next state D), or when the current state is F and w=0 (next state D).

assign Y1 = (y[0] && w) || // A to B
           (y[1] && ~w) || // B to D
           (y[2] && ~w) || // C to D
           (y[4] && ~w) || // E to D
           (y[5] && ~w);  // F to D

// Deriving the logic for Y3:
// - Y3 is high when the next state is D.
// Considering the transitions to D: B to D (w=0), C to D (w=0), E to D (w=0), F to D (w=0), D to D is not applicable as per given transitions.
assign Y3 = (y[1] && ~w) || // B to D
           (y[2] && ~w) || // C to D
           (y[4] && ~w) || // E to D
           (y[5] && ~w);  // F to D

endmodule
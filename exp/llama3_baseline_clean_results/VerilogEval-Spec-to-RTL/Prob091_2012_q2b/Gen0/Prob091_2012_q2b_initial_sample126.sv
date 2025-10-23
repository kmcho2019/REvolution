module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// Y1 is the input to state flip-flop y[1], corresponding to state B
// It is set when the current state is A (y[0] is 1) and w is 0, or
// when the current state is B (y[1] is 1) and w is 0, or
// considering the encoding and transitions, specifically for B (y[1])
assign Y1 = (y[0] & ~w) | (y[1] & ~w) | (y[3] & ~w);

// Y3 is the input to state flip-flop y[3], corresponding to state D
// It is set when the current state is B (y[1] is 1) and w is 0, or
// when the current state is C (y[2] is 1) and w is 0, or
// when the current state is D (y[3] is 1) and w is 0, or
// when the current state is E (y[4] is 1) and w is 0
assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[3] & ~w) | (y[4] & ~w);

endmodule
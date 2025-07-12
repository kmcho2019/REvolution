module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Y1 is set if next state is B or D
// This occurs when current state is A and input is 1 (going to B),
// or when current state is B and input is 0 (going to D),
// or when current state is any state that transitions to D (B with input 0, C with input 0, D with input 0, E with input 0, F with input 0)
assign Y1 = (y[0] & w) |  // A to B
           (y[1] & ~w) |  // B to D
           (y[1] & ~w) |  // B to D (covered above)
           (y[2] & ~w) |  // C to D
           (y[3] & ~w) |  // D to D (actually goes to A on 0, but D to D on 1 is not a condition for Y1)
           (y[4] & ~w) |  // E to D
           (y[5] & ~w);  // F to D

// Y3 is set if next state is D
// This occurs when current state is B and input is 0,
// or when current state is C and input is 0,
// or when current state is E and input is 0,
// or when current state is F and input is 0,
// or when current state is D and input is 0 (D to A, not to D, so not included)
assign Y3 = (y[1] & ~w) |  // B to D
           (y[2] & ~w) |  // C to D
           (y[4] & ~w) |  // E to D
           (y[5] & ~w);  // F to D

endmodule
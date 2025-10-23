module TopModule(
    input [5:0] y,  // Current state
    input w,        // Input signal
    output Y1,      // Next-state signal for y[1]
    output Y3       // Next-state signal for y[3]
);

// Since the one-hot encoding is used, y[0] corresponds to state A, y[1] to B, and so on.
// The transitions are based on the provided state machine.

// Logic equation for Y1 (next-state signal for y[1], state B):
// Y1 is 1 when the current state is A and w = 1.
assign Y1 = y[0] & w;

// Logic equation for Y3 (next-state signal for y[3], state D):
// Y3 is 1 when the current state is B and w = 1, or C and w = 1, or E and w = 0, or F and w = 1.
assign Y3 = (y[1] & w) | (y[2] & w) | (y[4] & ~w) | (y[5] & w);

endmodule
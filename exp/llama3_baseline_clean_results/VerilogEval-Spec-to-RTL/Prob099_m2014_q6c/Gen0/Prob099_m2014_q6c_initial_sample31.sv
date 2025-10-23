module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// One-hot encoding for states A to F
// A: 000001, B: 000010, C: 000100, D: 001000, E: 010000, F: 100000

// Next-state signal Y2 (y[1]) will be '1' if the next state is B
assign Y2 = (~y[5] & ~y[4] & ~y[3] & ~y[2] & y[1] & ~y[0] & w) |  // Current state is B and w = 1
           (~y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & y[0] & ~w);  // Current state is A and w = 0

// Next-state signal Y4 (y[3]) will be '1' if the next state is D
assign Y4 = (~y[5] & ~y[4] & ~y[3] & ~y[2] & y[1] & ~y[0] & w) |  // Current state is B and w = 1
           (~y[5] & ~y[4] & ~y[3] & y[2] & ~y[1] & ~y[0] & w) |  // Current state is C and w = 1
           (~y[5] & ~y[4] & y[3] & ~y[2] & ~y[1] & ~y[0] & w) |  // Current state is D and w = 1
           (~y[5] & y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0] & w) |  // Current state is E and w = 1
           (y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0] & w);  // Current state is F and w = 1

// Output signals Y1 and Y3
assign Y1 = y[0];
assign Y3 = y[2];

endmodule
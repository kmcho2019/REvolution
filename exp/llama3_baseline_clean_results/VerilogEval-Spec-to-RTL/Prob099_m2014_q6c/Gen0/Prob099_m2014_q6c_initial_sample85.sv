module TopModule(
    input  [5:0] y,  // 6-bit state
    input  w,      // control input
    output Y1,     // next-state signal for y[0]
    output Y3      // next-state signal for y[2]
);

// Since we are using one-hot encoding, the current state is represented by a single 1 in the 6-bit vector y.
// We derive the logic equations for Y1 and Y3 based on the state transitions.

// Y1 (next state for A) is 1 if current state is D and w is 0.
assign Y1 = y[3] & ~w;

// Y3 (next state for C) is 1 if current state is F and w is 1, or if current state is B and w is 0.
assign Y3 = (y[5] & w) | (y[1] & ~w);

endmodule
module TopModule(
    input  [5:0] y,  // one-hot encoded state
    input  w,
    output Y1,     // next-state signal for state B
    output Y3      // next-state signal for state D
);

// Next-state signal Y1 (state B) is 1 when current state is A and w is 1
assign Y1 = y[0] & w;

// Next-state signal Y3 (state D) is 1 when current state is B, C, E, or F and w is 1, 
// or when current state is D and w is 0
assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w | y[3] & ~w;

endmodule
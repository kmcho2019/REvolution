module TopModule(
    input [5:0] y,  // One-hot encoded state
    input w,
    output Y1,    // Next-state signal for y[0]
    output Y3     // Next-state signal for y[2]
);

// Y1 is 1 when the next state is A, which can be reached from D when w = 1
assign Y1 = y[3] & w;

// Y3 is 1 when the next state is C, which can be reached from B or F when w = 0
assign Y3 = (y[1] & ~w) | (y[5] & ~w);

endmodule
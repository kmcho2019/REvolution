module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Y1 should be high when transitioning to state B
// This happens when in state A (y[0] is high) and w is 1
assign Y1 = y[0] & w;

// Y3 should be high when transitioning to state D
// This can happen from states B, C, E, or F when w is 0, or inherently when in state D
assign Y3 = (~w) & (y[1] | y[2] | y[4] | y[5]);

endmodule
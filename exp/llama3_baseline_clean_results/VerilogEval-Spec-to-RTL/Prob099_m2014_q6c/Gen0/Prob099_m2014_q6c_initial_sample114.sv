module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// State A: y[5:0] = 000001
// State B: y[5:0] = 000010
// State C: y[5:0] = 000100
// State D: y[5:0] = 001000
// State E: y[5:0] = 010000
// State F: y[5:0] = 100000

// Next-state signal Y1 (corresponding to state B)
assign Y1 = (y[0] && !w) || (y[5] && w);

// Next-state signal Y3 (corresponding to state D)
assign Y3 = (y[1] && w) || (y[2] && w) || (y[4] && w) || (y[3] && !w);

endmodule
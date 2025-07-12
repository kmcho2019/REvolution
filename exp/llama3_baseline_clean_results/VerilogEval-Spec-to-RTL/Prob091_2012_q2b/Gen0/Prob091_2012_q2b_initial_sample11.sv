module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// State A is 000001, State B is 000010, State C is 000100, State D is 001000, State E is 010000, State F is 100000
// Y1 corresponds to state B (y[1])
// Y3 corresponds to state D (y[3])

assign Y1 = (y[0] && !w) || (y[1] && !w);  // State A to B or stay in B when w is 0
assign Y3 = (y[1] && !w) || (y[2] && !w) || (y[3] && !w) || (y[4] && !w);  // State B, C, D, or E to D when w is 0

endmodule
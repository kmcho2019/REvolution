module TopModule (
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// One-hot encoding for states A, B, C, D, E, F
// A: 000001, B: 000010, C: 000100, D: 001000, E: 010000, F: 100000

// Next-state signal Y2 (state B)
// State B is reached from state A when w is 0
assign Y2 = (~w & y[0]);

// Next-state signal Y4 (state D)
// State D is reached from states B, C, E, or F when w is 1, or from state D when w is 0
assign Y4 = (w & (y[1] | y[2] | y[4] | y[5])) | (~w & y[3]);

// Outputs Y1 and Y3
assign Y1 = y[0];
assign Y3 = y[3];

endmodule
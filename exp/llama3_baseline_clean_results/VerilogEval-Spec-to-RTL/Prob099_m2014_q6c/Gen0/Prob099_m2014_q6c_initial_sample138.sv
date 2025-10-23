module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// One-hot encoding for states A, B, C, D, E, F
// A: 000001, B: 000010, C: 000100, D: 001000, E: 010000, F: 100000

// Next-state signal Y2 (state B)
// A transitions to B when w is 0
// D transitions to B when w is 1
assign Y2 = (~w & y[0]) | (w & y[3]);

// Next-state signal Y4 (state D)
// B transitions to D when w is 1
// C transitions to D when w is 1
// E transitions to D when w is 1
// F transitions to D when w is 1
assign Y4 = (w & (y[1] | y[2] | y[4] | y[5]));

// Output assignments
assign Y1 = y[0];
assign Y3 = y[3];

endmodule
module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// One-hot encoding for states A, B, C, D, E, F
// A = 000001, B = 000010, C = 000100, D = 001000, E = 010000, F = 100000

// Next-state logic for Y1 (y[1]) - State B
assign Y1 = (y[0] && !w); // Transition from A to B when w = 0

// Next-state logic for Y3 (y[3]) - State D
assign Y3 = (!w && y[1]) || (!w && y[2]) || (w && y[4]); 
// Transition to D from B, C, or E under respective conditions

endmodule
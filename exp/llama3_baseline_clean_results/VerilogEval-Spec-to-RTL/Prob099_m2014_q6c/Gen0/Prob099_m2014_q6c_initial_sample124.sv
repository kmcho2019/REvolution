module TopModule(
    input  [5:0] y,  // Current state
    input       w,  // Input
    output      Y1, // Next state signal for state B
    output      Y3  // Next state signal for state D
);

// One-hot encoding for states A through F
// A: 000001, B: 000010, C: 000100, D: 001000, E: 010000, F: 100000

// Derive next-state signal Y1 (state B)
assign Y1 = (y[0] && !w) || (y[5] && !w);

// Derive next-state signal Y3 (state D)
assign Y3 = (y[1] && w) || (y[2] && w) || (y[3] && w) || (y[4] && w);

endmodule
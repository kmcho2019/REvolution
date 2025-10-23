module TopModule(
    input  [5:0] y,  // Current state
    input  w,      // Input signal
    output Y2,     // Next state signal for y[1]
    output Y4      // Next state signal for y[3]
);

// One-hot encoding: y[5:0] = 000001, 000010, 000100, 001000, 010000, 100000 for states A, B, C, D, E, F, respectively

// Next-state logic for Y2 (y[1] - State B)
assign Y2 = (y[0] && !w);  // Transition from A to B when w is '0'

// Next-state logic for Y4 (y[3] - State D)
assign Y4 = (y[1] && w) || (y[2] && w) || (y[4] && w);  // Transitions to D from B, C, or E when w is '1'

endmodule